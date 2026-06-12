import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sheep/features/seller/product/widget/section_title.dart';
import 'package:sheep/util/constants/app_colors.dart';

class AuctionImagesSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onTap;
  final Function(int index) onDelete;

  const AuctionImagesSection({
    super.key,
    required this.images,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE7E7E7);

    final totalCount = images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('صور المزاد'),
        const SizedBox(height: 12),

        /// 🔥 Upload Box (same product style)
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.photo_camera_outlined,
                        size: 35,
                        color: Color(0xFFC7C7C7),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  totalCount == 0
                      ? 'اضغط لاختيار الصور'
                      : 'إضافة المزيد ($totalCount)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// 🔥 GRID (same product style)
        if (totalCount > 0)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCount,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      images[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// ❌ delete
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => onDelete(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

        const SizedBox(height: 10),

        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'يمكنك إضافة حتى 6 صور',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F7F7F),
            ),
          ),
        ),
      ],
    );
  }
}