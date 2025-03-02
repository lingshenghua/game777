import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game777/core/cache/smart_image_cache.dart';
import 'package:shimmer/shimmer.dart';

class SmartImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BorderRadius borderRadius;
  final bool isCircle;
  final bool enableShimmer;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Duration shimmerDuration;
  final Widget? errorWidget;
  final Map<String, String>? headers;

  const SmartImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.isCircle = false,
    this.enableShimmer = true,
    this.shimmerBaseColor = const Color(0xFFEEEEEE),
    this.shimmerHighlightColor = const Color(0xFFFAFAFA),
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.errorWidget,
    this.headers,
  }) : assert(!isCircle || (width == height && width != null), '圆形图片需要宽高相等且不为空');

  factory SmartImage.circle({
    required String url,
    double? size,
    Key? key,
    BoxFit fit = BoxFit.cover,
    Color? color,
    bool enableShimmer = true,
  }) {
    return SmartImage(
      key: key,
      url: url,
      width: size,
      height: size,
      fit: fit,
      color: color,
      isCircle: true,
      enableShimmer: enableShimmer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ShapeWrapper(
      isCircle: isCircle,
      borderRadius: borderRadius,
      child: _buildImageContent(),
    );
  }

  Widget _buildImageContent() {
    if (_isSvg()) {
      return _buildSvg();
    } else if (_isAsset()) {
      return _buildAssetImage();
    } else {
      return _buildNetworkImage();
    }
  }

  bool _isSvg() {
    final ext = _getFileExtension();
    return ext == 'svg' || _isSvgMimeType();
  }

  bool _isAsset() => url.startsWith('assets/');

  String _getFileExtension() {
    try {
      final path = url.split(RegExp(r'[?#]')).first;
      return path.split('.').last.toLowerCase();
    } catch (_) {
      return '';
    }
  }

  bool _isSvgMimeType() {
    if (!url.startsWith('http')) return false;
    final mimeType = url.split(';').first.split(':').last;
    return mimeType == 'image/svg+xml';
  }

  Widget _buildSvg() {
    try {
      if (url.startsWith('http')) {
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          placeholderBuilder: _buildShimmer,
        );
      }
      return SvgPicture.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } catch (e) {
      return _buildErrorWidget();
    }
  }

  Widget _buildAssetImage() {
    return Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (_, __, ___) => _buildErrorWidget(),
    );
  }

  Widget _buildNetworkImage() {
    return SmartImageCache().cachedImage(
      url: url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      httpHeaders: headers,
      placeholder: _buildShimmer(null),
      errorWidget: _buildErrorWidget(),
      imageBuilder: (context, imageProvider) => Image(
        image: imageProvider,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }

  Widget _buildShimmer(BuildContext? context) {
    final shimmer = Shimmer(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          shimmerBaseColor,
          shimmerHighlightColor,
          shimmerBaseColor,
        ],
        stops: const [0.1, 0.5, 0.9],
      ),
      period: shimmerDuration,
      child: Container(
        color: Colors.white,
        width: width,
        height: height,
      ),
    );

    return enableShimmer ? shimmer : Container(color: shimmerBaseColor);
  }

  Widget _buildErrorWidget() {
    return errorWidget ?? const Icon(Icons.broken_image, size: 40);
  }
}

class _ShapeWrapper extends StatelessWidget {
  final bool isCircle;
  final BorderRadius borderRadius;
  final Widget child;

  const _ShapeWrapper({
    required this.isCircle,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isCircle
          ? ClipOval(child: child)
          : borderRadius != BorderRadius.zero
              ? ClipRRect(borderRadius: borderRadius, child: child)
              : child,
    );
  }
}
