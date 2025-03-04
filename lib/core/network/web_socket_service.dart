import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  String? _authToken;
  String? _deviceId;

  /// 初始化服务（应用启动时调用）
  Future<void> initialize({required String deviceId}) async {
    _deviceId = deviceId;
    _authToken = await _fetchAuthToken();
  }

  /// 获取认证 Token（示例）
  Future<String> _fetchAuthToken() async {
    /// 实现从安全存储获取或请求新 Token
    return 'encrypted_auth_token';
  }

  /// 建立安全连接
  Future<void> connect() async {
    try {
      final uri = _buildSecureUri();
      _channel = WebSocketChannel.connect(uri);

      /// 监听认证响应
      _channel!.stream.listen((data) {
        final response = jsonDecode(data);
        if (response['type'] == 'AUTH_SUCCESS') {
          _onConnected();
        } else {
          throw Exception('认证失败: ${response['message']}');
        }
      }, onError: _handleError);

      /// 发送认证请求
      _sendAuthMessage();
    } catch (e) {
      _handleError(e);
    }
  }

  /// 构造安全 URI
  Uri _buildSecureUri() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final signature = _generateSignature(timestamp);

    return Uri.parse(
      'wss://your-api.com/ws'
          '?deviceId=$_deviceId'
          '&timestamp=$timestamp'
          '&sig=$signature',
    );
  }

  /// 生成签名
  String _generateSignature(int timestamp) {
    final key = utf8.encode('your_secret_key');
    final data = '${_deviceId}_$timestamp';
    final hMac = Hmac(sha256, key);
    return hMac.convert(utf8.encode(data)).toString();
  }

  /// 发送认证消息
  void _sendAuthMessage() {
    _channel!.sink.add(jsonEncode({
      'type': 'AUTH_REQUEST',
      'token': _authToken,
    }));
  }

  /// 连接成功处理
  void _onConnected() {
    print('WebSocket 认证成功，连接已建立');
    // 开始心跳检测等后续操作
  }

  /// 统一错误处理
  void _handleError(dynamic error) {
    print('WebSocket 错误: $error');
    // 实现重连逻辑或通知 UI
  }

  /// 关闭连接
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}