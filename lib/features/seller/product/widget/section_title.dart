import 'package:flutter/material.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF4D4D4D),
    );
  }
}
