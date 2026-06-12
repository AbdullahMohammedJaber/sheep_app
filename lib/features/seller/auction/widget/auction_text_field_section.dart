import 'package:flutter/material.dart';
import 'package:sheep/features/seller/product/widget/section_title.dart';

 
class AuctionTextFieldSection extends StatelessWidget {
  final String title;
  final Widget child;

  const AuctionTextFieldSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}