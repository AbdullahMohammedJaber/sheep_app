import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheep/util/constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool enabled;
  final String? initialValue;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final AutovalidateMode? autovalidateMode;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
    this.initialValue,
    this.textAlign = TextAlign.right,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 12.0,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.inputFormatters,
    this.autofocus = false,
    this.autovalidateMode,
    this.onSaved,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3142),
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],

        // TextFormField
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          readOnly: widget.readOnly,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          textAlign: widget.textAlign,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          autovalidateMode: widget.autovalidateMode,
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmitted,
          style:
              widget.textStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3142),
              ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
                widget.hintStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                ),
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,

            prefixIcon: widget.prefixIcon,

            // Suffix Icon (custom only)
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[400],
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : SizedBox(),

            // Content Padding
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

            // Border Styles
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.border,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.border,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? AppColors.border,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFFE74C3C),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 2),
            ),

            // Error Style
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE74C3C),
            ),

            // Counter (for maxLength)
            counterText: '',
          ),
        ),
      ],
    );
  }
}
