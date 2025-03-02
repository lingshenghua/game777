import 'package:flutter/material.dart';
import 'package:game777/common/export.dart';

class SmartText extends StatelessWidget {
  final String text;
  final TextType? type;
  final TextStyle? style;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool inheritTheme;

  /// 是否启用多语言
  final bool useLocalization;
  final LanguageEnum? translationModule;
  final List<dynamic>? translationValueList;

  const SmartText(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.inheritTheme = true,
    this.useLocalization = false,
    this.translationModule = LanguageEnum.common,
    this.translationValueList,
  });

  @override
  Widget build(BuildContext context) {
    /// 获取主题配置
    final theme = inheritTheme ? Theme.of(context) : ThemeData();

    /// 多语言处理逻辑
    final displayText = _getLocalizedText();

    final defaultStyle = _getDefaultStyle(context, theme);

    /// 合并样式层次：type默认样式 < 直接样式参数 < style参数
    final mergedStyle = defaultStyle
        .copyWith(
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          height: height,
        )
        .merge(style);

    return Text(
      displayText,
      style: mergedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      strutStyle: StrutStyle.fromTextStyle(mergedStyle),
    );
  }

  TextStyle _getDefaultStyle(BuildContext context, ThemeData theme) {
    /// 根据类型获取基础样式
    final baseStyle = switch (type ?? TextType.body) {
      TextType.display => TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily ?? theme.textTheme.displayLarge?.fontFamily,
        ),
      TextType.h1 => TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily ?? theme.textTheme.headlineLarge?.fontFamily,
        ),
      TextType.h2 => TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily ?? theme.textTheme.headlineMedium?.fontFamily,
        ),
      TextType.body => TextStyle(
          fontSize: 16,
          height: 1.5,
          fontFamily: fontFamily ?? theme.textTheme.bodyLarge?.fontFamily,
        ),
      TextType.caption => TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
          fontFamily: fontFamily ?? theme.textTheme.bodySmall?.fontFamily,
        ),
      TextType.button => TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
          fontFamily: fontFamily ?? theme.textTheme.labelLarge?.fontFamily,
        ),
    };

    /// 与主题默认样式合并
    return (theme.textTheme.bodyLarge ?? const TextStyle()).merge(baseStyle);
  }

  /// 翻译文本
  String _getLocalizedText() {
    if (!useLocalization) return text;
    try {
      return I10nUtil.tr(text, module: translationModule, valueList: translationValueList);
    } catch (e) {
      debugPrint('Translation failed: $e');
      return text;
    }
  }
}

/// 扩展的样式类型枚举
enum TextType {
  display, // 超大标题
  h1, // 主标题
  h2, // 副标题
  body, // 正文
  caption, // 辅助文本
  button, // 按钮文本
}
