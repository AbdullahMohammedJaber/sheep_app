// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImagesSlider extends StatefulWidget {
  final List<String> images;

  const ProductImagesSlider({super.key, required this.images});

  @override
  State<ProductImagesSlider> createState() => _ProductImagesSliderState();
}

class _ProductImagesSliderState extends State<ProductImagesSlider> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),

           Positioned(
            bottom: 8,
            child: SmoothPageIndicator(
              controller: _controller,
              count: widget.images.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}