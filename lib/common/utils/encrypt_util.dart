import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart' as crypto;

class EncryptUtil {
  EncryptUtil._privateConstructor();

  static final EncryptUtil instance = EncryptUtil._privateConstructor();

  /// 使用一个密钥来生成 hMac 哈希
  Future<String> hMacEncrypt(String data, {String? secretKey, required crypto.Hash hashAlgorithm}) async {
    /// 使用动态传入的密钥，如果没有提供，则使用默认的 secretKey
    String key = secretKey ?? '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

    if (data.isEmpty) return "";

    try {
      /// 转换消息和密钥为字节数组
      List<int> keyBytes = utf8.encode(key);
      List<int> dataBytes = utf8.encode(data);

      /// 创建 hMac 对象，使用指定的哈希算法
      var hMac = Hmac(hashAlgorithm, keyBytes);

      /// 这里传入的是 crypto.Hash 类型的哈希算法
      var digest = hMac.convert(dataBytes);
      return base64Encode(digest.bytes);
    } catch (e) {
      throw Exception('Error in encryption: $e');
    }
  }

  /// 专门用于 SHA-256 的方法
  Future<String> sha256(String data) async {
    return await hMacEncrypt(data, hashAlgorithm: crypto.sha256);

    /// 使用 crypto.sha256 传入
  }

  /// 如果将来需要支持其他算法，可以继续添加类似的函数
  Future<String> sha1(String data) async {
    return await hMacEncrypt(data, hashAlgorithm: crypto.sha1);

    /// 使用 crypto.sha1 传入
  }
}
