import 'package:flutter/material.dart';
import 'package:sheep/util/theme/font_manager.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  /// 🆕
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE7E7E7);
    const hintColor = Color(0xFFB9B9B9);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      onChanged: onChanged,
      validator: validator,

      /// ✅ التعديل هنا
      readOnly: readOnly,
      onTap: onTap,

      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Color(0xFFE53935),
          fontSize: 13,
          fontFamily: FontConstants.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: hintColor, fontSize: 15),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: maxLines > 1 ? 18 : 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.2),
        ),
      ),
    );
  }
}