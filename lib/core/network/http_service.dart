import 'dart:async';
import 'package:dio/dio.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';
import 'package:synchronized/synchronized.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

typedef EntityDecoder<T> = T Function(dynamic json);
typedef ErrorTransformer = DioException Function(DioException e);

/// HTTP 服务核心类
class HttpService {
  final Dio _dio;
  final Lock _requestLock = Lock();
  final Map<String, int> _throttleTimestamps = {};
  final HttpServiceConfig config;

  HttpService({
    HttpServiceConfig? config,
    List<Interceptor>? interceptors,
  })  : config = config ?? HttpServiceConfig(),
        _dio = Dio() {
    /// 初始化基础配置
    _dio.options
      ..baseUrl = this.config.baseUrl
      ..connectTimeout = this.config.connectTimeout
      ..receiveTimeout = this.config.receiveTimeout;

    /// 拦截器
    _dio.interceptors.addAll([
      /// 加密拦截器
      _createEncryptInterceptor(),

      if (this.config.enableLogging)
        PrettyDioLogger(
          requestHeader: this.config.logLevel >= HttpLogLevel.headers,
          requestBody: this.config.logLevel >= HttpLogLevel.body,
          responseBody: this.config.logLevel >= HttpLogLevel.body,
          error: this.config.logLevel >= HttpLogLevel.errors,
        ),
      ...?interceptors,
    ]);
  }

  /// 核心请求方法
  Future<ResultBean<T>> request<T>({
    required HttpMethod method,
    required String path,
    EntityDecoder<T>? decoder,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool checkBusinessStatus = true,
    bool enableThrottle = true,
    ErrorTransformer? errorTransformer,
  }) async {
    try {
      final response = await _executeRequest(
        method: method,
        path: path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        enableThrottle: enableThrottle,
      );

      return _processResponse<T>(
        response: response,
        decoder: decoder,
        checkBusinessStatus: checkBusinessStatus,
      );
    } on DioException catch (e) {
      throw errorTransformer?.call(e) ?? _enhanceError(e);
    }
  }

  /// 分页专用请求
  Future<ResultBean<PageInfo<T>>> paginatedRequest<T>({
    required HttpMethod method,
    required String path,
    required EntityDecoder<T> itemDecoder,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String recordsField = CommonConst.records,
    bool checkBusinessStatus = true,
    bool enableThrottle = true,
  }) async {
    return request<PageInfo<T>>(
      method: method,
      path: path,
      decoder: (json) => _parsePaginatedData(
        json,
        itemDecoder: itemDecoder,
        recordsField: recordsField,
      ),
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      checkBusinessStatus: checkBusinessStatus,
      enableThrottle: enableThrottle,
    );
  }

  /// 执行网络请求
  Future<Response<dynamic>> _executeRequest({
    required HttpMethod method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    required bool enableThrottle,
  }) async {
    final requestKey = _generateRequestKey(
      method: method,
      path: path,
      data: data,
      queryParameters: queryParameters,
    );

    return _requestLock.synchronized(() async {
      if (enableThrottle) _checkThrottle(requestKey);

      try {
        return await _dio.request(
          path,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: method.value),
          cancelToken: cancelToken,
        );
      } finally {
        if (enableThrottle) _clearThrottleRecord(requestKey);
      }
    });
  }

  /// 响应处理
  ResultBean<T> _processResponse<T>({
    required Response<dynamic> response,
    EntityDecoder<T>? decoder,
    required bool checkBusinessStatus,
  }) {
    _validateHttpResponse(response);

    final result = ResultBean<T>.fromJson(
      json: response.data as Map<String, dynamic>,
      fromJsonT: decoder,
    );

    if (checkBusinessStatus) {
      _validateBusinessResult(result, response);
    }

    return result;
  }

  ///  分页处理
  PageInfo<T> _parsePaginatedData<T>(
    dynamic json, {
    required EntityDecoder<T> itemDecoder,
    required String recordsField,
  }) {
    final data = json as Map<String, dynamic>;
    final records = (data[recordsField] as List).map<T>((item) {
      if (item is Map<String, dynamic>) {
        return itemDecoder(item);
      }
      throw ArgumentError('分页记录项格式错误');
    }).toList();

    return PageInfo<T>.fromJson(data).copyWith(records: records);
  }

  ///  防抖机制
  String _generateRequestKey({
    required HttpMethod method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    final uri = Uri(path: path, queryParameters: queryParameters);
    return '${method.value}:${uri.toString()}';
  }

  void _checkThrottle(String requestKey) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _throttleTimestamps[requestKey] ?? 0;

    if (now - lastTime < config.throttleDuration.inMilliseconds) {
      throw DioException(
        requestOptions: RequestOptions(path: requestKey),
        error: '操作过于频繁，请稍后再试',
        type: DioExceptionType.cancel,
      );
    }
    _throttleTimestamps[requestKey] = now;
  }

  void _clearThrottleRecord(String requestKey) {
    _throttleTimestamps.remove(requestKey);
  }

  ///  校验系统
  void _validateHttpResponse(Response response) {
    /// HTTP 状态码检查
    if (response.statusCode! < 200 || response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    /// 响应数据格式检查
    if (response.data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: '无效的响应格式',
        type: DioExceptionType.badResponse,
      );
    }
  }

  void _validateBusinessResult<T>(ResultBean<T> result, Response response) {
    if (result.code != ResponseCodeEnum.success.code) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: result.message ?? '业务请求失败',
        type: DioExceptionType.badResponse,
        response: response,
      );
    }
  }

  /// 添加加密参数
  _encryptParam(RequestOptions options) async {
    String path = options.uri.path;
    String query = options.uri.query;
    String tempSortString = UrlUtil.sortString(query, options.data);
    String finalEncryptStr = path + tempSortString;
    String encryptStr = await EncryptUtil.instance.sha256(finalEncryptStr);
    options.headers[CommonConst.sign] = encryptStr;
  }

  /// 创建加密拦截器
  Interceptor _createEncryptInterceptor() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        try {
          options.headers["token"] = "";
          options.headers["app_channel"] = "ANDROID";
          options.headers["version"] = "1.0.2";
          options.headers["device_id"] = "3bf7da1e7bb04ed609a50f90a6c1fcfa64db0720e2af2d25661ac47d29db9731";

          await _encryptParam(options); // 执行加密
          handler.next(options); // 继续请求流程
        } catch (e) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: '参数加密失败: $e',
              type: DioExceptionType.unknown,
            ),
          );
        }
      },
    );
  }

  ///  错误处理
  DioException _enhanceError(DioException e) {
    String message = '网络请求失败';
    dynamic errorData;

    if (e.response?.data is Map<String, dynamic>) {
      errorData = e.response!.data as Map<String, dynamic>;
      message = errorData['message'] ?? message;
    }

    return e.copyWith(
      error: message,
      stackTrace: e.stackTrace,
    );
  }
}
