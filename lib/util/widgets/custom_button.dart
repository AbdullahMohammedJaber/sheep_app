// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class CustomButton extends StatefulWidget {
  final dynamic title;
  final Color? colorTitle;
  final double? sizeTitle;
  final FontWeight? fontWeight;
  final Color? colorButton;
  final double? heightButton;
  final Function()? onTap;
  final double? radius;

  const CustomButton({
    super.key,
    this.title,
    this.colorTitle = Colors.white,
    this.sizeTitle = 14,
    this.radius = 12,
    this.heightButton = 48,
    this.onTap,
    this.fontWeight,
    this.colorButton,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _radiusAnimation = Tween<double>(
      begin: widget.radius ?? 12,
      end: (widget.heightButton ?? 48) / 2,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void didUpdateWidget(CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.title is bool && widget.title == true) {
      _controller.forward();
    } else if (oldWidget.title is bool && oldWidget.title == true) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.title is bool && widget.title == true;

    return GestureDetector(
      onTap: isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: widget.heightButton,
            width: isLoading ? widget.heightButton : null,
            decoration: BoxDecoration(
              color: widget.colorButton ?? AppColors.primary,
              borderRadius: BorderRadius.circular(_radiusAnimation.value),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            key: const ValueKey('loading'),
                            color: AppColors.white,
                            strokeWidth: 2.5,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                        : CustomText(
                          text: widget.title!,
                          key: const ValueKey('text'),
                          fontSize: widget.sizeTitle,
                          fontWeight: widget.fontWeight ?? FontWeight.w600,
                          color: widget.colorTitle!,
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
