import 'package:dio/dio.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/consts/export.dart';
import 'package:synchronized/synchronized.dart';

/// HTTP 配置类
class HttpServiceConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration throttleDuration;
  final bool enableLogging;
  final HttpLogLevel logLevel;
  final Lock _headerLock = Lock();
  Map<String, dynamic> defaultHeaders;
  final Future<String> Function(RequestOptions) signatureBuilder;
  final String signHeaderName;
  final String defaultErrorMessage;

  HttpServiceConfig({
    this.baseUrl = 'http://test.idbattleplat.com:9000',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.throttleDuration = const Duration(seconds: 1),
    this.enableLogging = true,
    this.logLevel = HttpLogLevel.body,
    this.defaultHeaders = const {},
    this.defaultErrorMessage = "请求失败",
    this.signatureBuilder = _signatureBuilder,
    this.signHeaderName = CommonConst.sign,
  });

  /// 线程安全的头部更新方法
  Future<void> updateHeader(String key, dynamic value) async {
    await _headerLock.synchronized(() {
      defaultHeaders[key] = value;
    });
  }

  /// 批量更新方法
  Future<void> updateHeaders(Map<String, dynamic> updates) async {
    await _headerLock.synchronized(() {
      defaultHeaders.addAll(updates);
    });
  }

  /// 获取当前头部的不可变副本
  Map<String, dynamic> get currentHeaders => Map.unmodifiable(defaultHeaders);

  /// 默认签名生成实现
  static Future<String> _signatureBuilder(RequestOptions options) async {
    final path = options.uri.path;
    final query = options.uri.query;
    final sortedParams = UrlUtil.sortString(query, options.data);
    return EncryptUtil.instance.sha256(path + sortedParams);
  }
}
