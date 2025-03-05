import 'package:flutter/material.dart';

/// 按钮类型枚举
enum ButtonType {
  primary,    // 主要按钮
  secondary,  // 次要按钮
  text,       // 文本按钮
  outline,    // 边框按钮
}

/// 按钮尺寸枚举
enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonType type;
  final ButtonSize size;
  final bool loading;
  final bool disabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double? width;
  final BorderSide? border;

  const CustomButton({
    super.key,
    required this.text,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius = 8,
    this.width,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 合并默认样式和自定义样式
    final resolvedStyle = _resolveButtonStyle(theme, isDarkMode);

    return Opacity(
      opacity: disabled ? 0.6 : 1.0,
      child: SizedBox(
        width: width,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: _getPadding(),
            backgroundColor: resolvedStyle.backgroundColor,
            foregroundColor: resolvedStyle.foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide.none,
            ),
            elevation: 0,
          ),
          onPressed: (disabled || loading) ? null : onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildContent(resolvedStyle.foregroundColor),
              if (loading) _buildLoader(),
            ],
          ),
        ),
      ),
    );
  }

  /// 解析按钮样式
  ButtonStyleConfig _resolveButtonStyle(ThemeData theme, bool isDarkMode) {
    Color? bgColor;
    Color? fgColor;
    BoxBorder? border;

    switch (type) {
      case ButtonType.primary:
        bgColor = backgroundColor ?? theme.primaryColor;
        fgColor = foregroundColor ?? theme.colorScheme.onPrimary;
        break;
      case ButtonType.secondary:
        bgColor = backgroundColor ?? (isDarkMode ? Colors.grey[800] : Colors.grey[200]);
        fgColor = foregroundColor ?? (isDarkMode ? Colors.white : Colors.black87);
        break;
      case ButtonType.text:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? theme.primaryColor;
        break;
      case ButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = foregroundColor ?? theme.primaryColor;
        border = (this.border ?? BorderSide(color: fgColor)) as BoxBorder?;
        break;
    }

    return ButtonStyleConfig(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      border: border,
    );
  }

  /// 构建加载指示器
  Widget _buildLoader() {
    return Positioned.fill(
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              foregroundColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建按钮内容
  Widget _buildContent(Color? color) {
    return AnimatedOpacity(
      opacity: loading ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: _getIconSize(), color: color),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 8),
            Icon(suffixIcon, size: _getIconSize(), color: color),
          ],
        ],
      ),
    );
  }

  // 尺寸相关计算
  EdgeInsetsGeometry _getPadding() {
    if (padding != null) return padding!;
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

/// 样式配置类
class ButtonStyleConfig {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BoxBorder? border;

  const ButtonStyleConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.border,
  });
}