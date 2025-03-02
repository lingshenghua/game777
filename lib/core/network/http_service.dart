import 'dart:async';
import 'package:dio/dio.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/export.dart';
import 'package:synchronized/synchronized.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

typedef EntityDecoder<T> = T Function(dynamic json);
typedef ErrorTransformer = DioException Function(DioException e);

class HttpService {
  final Dio _dio;
  final HttpServiceConfig config;
  final Lock _throttleLock = Lock();
  final Map<String, int> _throttleTimestamps = {};
  late final ErrorHandler _errorHandler;

  HttpService({
    HttpServiceConfig? config,
    List<Interceptor>? interceptors,
  })  : config = config ?? HttpServiceConfig(),
        _dio = Dio() {
    _errorHandler = ErrorHandler(this.config);
    _dio.options
      ..baseUrl = this.config.baseUrl
      ..connectTimeout = this.config.connectTimeout
      ..receiveTimeout = this.config.receiveTimeout;

    _dio.interceptors.addAll([
      /// 请求前处理
      RequestInterceptor(this.config),
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

  Future<BaseResultBean<T>> request<T>({
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
      throw errorTransformer?.call(e) ?? _errorHandler.enhanceError(e);
    }
  }

  Future<BaseResultBean<BasePageInfo<T>>> paginatedRequest<T>({
    required HttpMethod method,
    required String path,
    required EntityDecoder<T> itemDecoder,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String recordsField = CommonConst.records,
    bool checkBusinessStatus = true,
    bool enableThrottle = true,
  }) {
    return request<BasePageInfo<T>>(
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
  }

  BaseResultBean<T> _processResponse<T>({
    required Response<dynamic> response,
    EntityDecoder<T>? decoder,
    required bool checkBusinessStatus,
  }) {
    _validateHttpResponse(response);

    final result = BaseResultBean<T>.fromJson(
      json: response.data as Map<String, dynamic>,
      fromJsonT: decoder,
    );

    /// 业务逻辑处理
    if (checkBusinessStatus) _errorHandler.validateBusinessResult(result, response);

    return result;
  }

  void _checkThrottle(String requestKey) {
    _throttleLock.synchronized(() {
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
    });
  }

  void _clearThrottleRecord(String requestKey) {
    _throttleLock.synchronized(() {
      _throttleTimestamps.remove(requestKey);
    });
  }

  ///  分页处理
  BasePageInfo<T> _parsePaginatedData<T>(
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

    return BasePageInfo<T>.fromJson(data).copyWith(records: records);
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
}
