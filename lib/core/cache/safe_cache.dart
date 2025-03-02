import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// 安全存储管理器
/// 支持普通数据存储 + 敏感数据加密存储
/// 支持对象存储（自动JSON序列化）
class SafeCache {
  static final SafeCache _instance = SafeCache._internal();
  late SharedPreferences _prefs;
  late encrypt.Encrypter _encrypt;
  late encrypt.IV _iv;
  bool _isEncryptionReady = false;
  static const _secureStorage = FlutterSecureStorage();

  factory SafeCache() => _instance;

  SafeCache._internal();

  /// 初始化缓存系统（必须在应用启动时调用）
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _initEncryption();
  }

  /// 初始化加密系统
  Future<void> _initEncryption() async {
    try {
      // 从安全存储获取或创建加密密钥
      String? key = await _secureStorage.read(key: 'encryption_key');
      if (key == null) {
        final key = encrypt.Key.fromSecureRandom(32);
        await _secureStorage.write(
          key: 'encryption_key',
          value: key.base64,
        );
      }
      _iv = encrypt.IV.fromSecureRandom(16);
      _encrypt = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(key!)));
      _isEncryptionReady = true;
    } catch (e) {
      debugPrint('Encryption initialization failed: $e');
      _isEncryptionReady = false;
    }
  }

  /// 通用存储方法
  Future<bool> set<T>({
    required String key,
    required T value,
    bool encryptData = false,
  }) async {
    try {
      if (value == null) return delete(key: key);

      // 处理不同类型
      if (value is String) {
        return _setString(key, value, encryptData);
      } else if (value is int) {
        return _prefs.setInt(key, value);
      } else if (value is double) {
        return _prefs.setDouble(key, value);
      } else if (value is bool) {
        return _prefs.setBool(key, value);
      } else if (value is Map || value is List) {
        return _setObject(key, value, encryptData);
      }
      return false;
    } catch (e) {
      debugPrint('Cache set error: $e');
      return false;
    }
  }

  /// 获取数据（自动推断类型）
  T? get<T>(String key, {bool encrypted = false}) {
    try {
      if (encrypted && !_isEncryptionReady) return null;

      final dynamic value = _prefs.get(key);
      if (value == null) return null;

      if (encrypted) {
        return _decryptData(value as String) as T?;
      }

      // 自动类型转换
      if (T == int) return _prefs.getInt(key) as T?;
      if (T == double) return _prefs.getDouble(key) as T?;
      if (T == bool) return _prefs.getBool(key) as T?;
      if (T == String) return _prefs.getString(key) as T?;
      if (T == Map || T == List) return _getObject(key) as T?;

      return null;
    } catch (e) {
      debugPrint('Cache get error: $e');
      return null;
    }
  }

  /// 存储对象（自动序列化）
  Future<bool> _setObject(String key, dynamic object, bool encrypt) async {
    try {
      final jsonString = jsonEncode(object);
      return encrypt ? _setString(key, jsonString, true) : _prefs.setString(key, jsonString);
    } catch (e) {
      debugPrint('Object storage error: $e');
      return false;
    }
  }

  /// 获取存储的对象
  dynamic _getObject(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  /// 加密存储字符串
  Future<bool> _setString(String key, String value, bool encrypt) async {
    try {
      if (encrypt) {
        if (!_isEncryptionReady) return false;
        final encrypted = _encrypt.encrypt(value, iv: _iv);
        return _prefs.setString(key, encrypted.base64);
      }
      return _prefs.setString(key, value);
    } catch (e) {
      debugPrint('String storage error: $e');
      return false;
    }
  }

  /// 解密数据
  String? _decryptData(String encryptedData) {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      return _encrypt.decrypt(encrypted, iv: _iv);
    } catch (e) {
      debugPrint('Decryption failed: $e');
      return null;
    }
  }

  /// 删除数据
  Future<bool> delete({required String key}) => _prefs.remove(key);

  /// 清空所有缓存（慎用）
  Future<bool> clearAll() => _prefs.clear();
}
