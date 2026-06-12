import 'dart:io';

import 'package:flutter/material.dart';

class ProductImagesSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onTap;
  final Function(int) onRemove;

  const ProductImagesSection({
    super.key,
    required this.images,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: List.generate(images.length, (index) {
            return Stack(
              children: [
                Image.file(
                  images[index],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => onRemove(index),
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 80,
            color: Colors.grey.shade200,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}