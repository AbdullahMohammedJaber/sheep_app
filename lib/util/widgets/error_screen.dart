// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/theme/font_manager.dart';

class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    this.title,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

         
            Text(
              title ?? "حدث خطأ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// Message
            Text(
              message ??"" ,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 10),

            /// Retry Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:   Text(
                  AppStrings.try_again,
                  style: TextStyle(
                    fontFamily: FontConstants.fontFamily,
                    fontSize: 16 , color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}