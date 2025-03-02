import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 高级图片缓存系统
/// 功能特性：
/// 1. 内存+磁盘二级缓存
/// 2. 智能预加载队列
/// 3. 自动缓存清理（基于时间+大小）
/// 4. 内存占用监控
class SmartImageCache {
  static final SmartImageCache _instance = SmartImageCache._internal();

  factory SmartImageCache() => _instance;

  late BaseCacheManager _cacheManager;
  final _preloadQueue = <String>[];
  Timer? _cleanupTimer;
  static const _maxDiskSize = 500 * 1024 * 1024; // 500MB
  static const _maxMemoryCount = 150; // 最大内存缓存图片数

  SmartImageCache._internal() {
    _initCache();
    _startAutoClean();
  }

  void _initCache() {
    _cacheManager = CacheManager(Config(
      'image_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300,
    ));

    // 配置内存缓存
    PaintingBinding.instance.imageCache.maximumSize = _maxMemoryCount;
    PaintingBinding.instance.imageCache.clear();
  }

  /// 启动自动清理任务
  void _startAutoClean() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      _cleanExpiredCache();
    });
  }

  /// 清理过期缓存
  Future<void> _cleanExpiredCache() async {
    /// 清理磁盘缓存
    final cacheDir = await _cacheManager.getFileFromCache(''); // 获取缓存目录
    if (cacheDir != null) {
      final dir = cacheDir.file.parent;
      if (await dir.exists()) {
        final files = await dir.list().toList();
        files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

        int totalSize = 0;
        for (var file in files.cast<File>()) {
          totalSize += await file.length();
          if (totalSize > _maxDiskSize) {
            await file.delete();
          }
        }
      }
    }

    /// 清理内存缓存
    final imageCache = PaintingBinding.instance.imageCache;
    while (imageCache.liveImageCount + imageCache.pendingImageCount > _maxMemoryCount) {
      imageCache.clearLiveImages();
    }
  }

  /// 图片加载组件
  Widget cachedImage({
    required String url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
    Map<String, String>? httpHeaders,
    Widget? placeholder,
    Widget? errorWidget,
    ImageWidgetBuilder? imageBuilder,
  }) {
    _addToPreloadQueue(url);
    return CachedNetworkImage(
      imageUrl: url,
      cacheManager: _cacheManager,
      width: width,
      height: height,
      fit: fit,
      color: color,
      httpHeaders: httpHeaders,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      placeholder: placeholder != null ? (_, __) => placeholder : null,
      errorWidget: errorWidget != null ? (_, __, ___) => errorWidget : (_, __, ___) => const Icon(Icons.broken_image),
      imageBuilder: imageBuilder,
    );
  }

  /// 智能预加载系统
  void preloadImages(List<String> urls, {int concurrent = 3}) {
    urls = urls.where((url) => !_preloadQueue.contains(url)).toList();
    _preloadQueue.addAll(urls);

    _processPreloadQueue(concurrent);
  }

  void _addToPreloadQueue(String url) {
    if (!_preloadQueue.contains(url)) {
      _preloadQueue.add(url);
    }
  }

  void _processPreloadQueue(int concurrent) async {
    while (_preloadQueue.isNotEmpty) {
      /// 每次最多取 concurrent 个
      final chunk = _preloadQueue.take(concurrent).toList();
      await Future.wait(chunk.map(_loadToCache));
      _preloadQueue.removeWhere((url) => chunk.contains(url));
    }
  }

  Future<void> _loadToCache(String url) async {
    try {
      /// 先检查内存缓存
      if (await _isCachedInMemory(url)) return;

      /// 加载到磁盘缓存
      final file = await _cacheManager.getSingleFile(url);

      /// 预热内存缓存
      final provider = FileImage(file);
      provider.resolve(ImageConfiguration.empty);
    } catch (e) {
      debugPrint('Preload failed: $url - $e');
    }
  }

  /// 手动清理缓存
  Future<void> clearCache({bool memory = true, bool disk = false}) async {
    if (memory) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
    if (disk) {
      await _cacheManager.emptyCache();
    }
  }

  Future<bool> _isCachedInMemory(String url) async {
    try {
      final provider = CachedNetworkImageProvider(url);
      final key = await _generateCacheKey(provider);
      return PaintingBinding.instance.imageCache.containsKey(key);
    } catch (e) {
      debugPrint('缓存检测失败: $e');
      return false;
    }
  }

  Future<Object> _generateCacheKey(ImageProvider provider) async {
    final configuration = ImageConfiguration(
      bundle: rootBundle,
      devicePixelRatio: 1.0,
      locale: const Locale('en', 'US'),
      textDirection: TextDirection.ltr,
      size: const Size(300, 300),
      platform: TargetPlatform.android,
    );

    final key = await provider.obtainKey(configuration);
    return key.hashCode;
  }

  /// 释放资源
  void dispose() {
    _cleanupTimer?.cancel();
    clearCache(memory: true, disk: true);
  }
}
