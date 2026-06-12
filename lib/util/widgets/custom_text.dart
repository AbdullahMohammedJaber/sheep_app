import 'package:flutter/material.dart';
import 'package:sheep/util/theme/font_manager.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Get the base text style from the current theme (e.g. bodyMedium)
    final baseStyle = Theme.of(context).textTheme.bodyMedium;

    // Merge the base style with the provided generic properties or the specific style if provided
    final finalStyle =
        style ??
        baseStyle?.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: FontConstants.fontFamily,
        );

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
