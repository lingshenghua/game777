import 'package:game777/common/export.dart';

/// HTTP 配置类
class HttpServiceConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration throttleDuration;
  final bool enableLogging;
  final HttpLogLevel logLevel;

  HttpServiceConfig({
    this.baseUrl = 'http://test.idbattleplat.com:9000',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.throttleDuration = const Duration(seconds: 1),
    this.enableLogging = true,
    this.logLevel = HttpLogLevel.body,
  });
}
