import 'package:dio/dio.dart';
import 'package:game777/core/export.dart';

class RequestInterceptor extends Interceptor {
  final HttpServiceConfig config;

  RequestInterceptor(this.config);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      /// 添加默认请求头
      options.headers.addAll(config.defaultHeaders);

      /// 实时获取最新 headers
      final headers = config.currentHeaders;

      /// 合并请求头
      options.headers.addAll({
        ...headers,
        ...options.headers,
      });

      /// 生成签名
      final signature = await config.signatureBuilder(options);
      options.headers[config.signHeaderName] = signature;

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: '参数处理失败: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
