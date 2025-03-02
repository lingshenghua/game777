/// 应用程序全局缓存常量定义
final class CacheKeyConst {
  CacheKeyConst._();

  static const String appCacheKey = 'game_';

  static const String token = '${appCacheKey}token';
  static const String deviceId = '${appCacheKey}deviceId';
}
