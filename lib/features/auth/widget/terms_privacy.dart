import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheep/util/theme/font_manager.dart';

class TermsAndPrivacyText extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final Color? normalTextColor;
  final Color? linkColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const TermsAndPrivacyText({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.normalTextColor,
    this.linkColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        
        style: TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w400,
          
          color: normalTextColor ?? const Color(0xFF6B7280),
          fontFamily: FontConstants.fontFamily, // استخدم خط تطبيقك
          height: 1.6,
        ),
        children: [
          const TextSpan(text: 'بمتابعتك، فإنك توافق على '),
          TextSpan(
            text: 'شروط الخدمة',
            style: TextStyle(
              color: linkColor ?? const Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: linkColor ?? const Color(0xFFF59E0B),
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    if (onTermsTap != null) {
                      onTermsTap!();
                    }
                  },
          ),
          const TextSpan(text: ' و '),
          TextSpan(
            text: 'سياسة الخصوصية',
            style: TextStyle(
              color: linkColor ?? const Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: linkColor ?? const Color(0xFFF59E0B),
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    if (onPrivacyTap != null) {
                      onPrivacyTap!();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
