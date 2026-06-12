// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
 
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

 

Future<void> showLogoutDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) {
      return Center(child: _LogoutDialogContent(onConfirm: onConfirm));
    },
    transitionBuilder: (_, animation, __, child) {
      final scale = Curves.easeOutBack.transform(animation.value);

      return Transform.scale(
        scale: scale,
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _LogoutDialogContent extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialogContent({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.error.withOpacity(0.4),
                   AppColors.error.withOpacity(0.6)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            /// Title
            CustomText(
            text:  "تسجيل الخروج",
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),

            const SizedBox(height: 14),

            /// Message
            CustomText(
             text:   "هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟",
              textAlign: TextAlign.center,
              fontSize: 14,
              
              color: Colors.black87,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                    text:    "يمكنك تسجيل الدخول مرة أخرى في أي وقت.",
                      fontSize: 11.5,
                      color: AppColors.error,
                      
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(text: "إلغاء", color: AppColors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: CustomText(
                     text:   "تسجيل الخروج",
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showLoginRequiredDialog({
  required BuildContext context,
  required VoidCallback onLogin,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) {
      return Center(child: _LoginRequiredDialogContent(onLogin: onLogin));
    },
    transitionBuilder: (_, animation, __, child) {
      final scale = Curves.easeOutBack.transform(animation.value);

      return Transform.scale(
        scale: scale,
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _LoginRequiredDialogContent extends StatelessWidget {
  final VoidCallback onLogin;

  const _LoginRequiredDialogContent({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.4),
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 18),

            CustomText(
              text: "تسجيل الدخول مطلوب",
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),

            const SizedBox(height: 14),

            CustomText(
              text: "هذه الميزة تحتاج إلى تسجيل الدخول والمصادقة قبل المتابعة.",
              textAlign: TextAlign.center,
              fontSize: 14,
              color: Colors.black87,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      text: "يمكنك تصفح المزادات كزائر، لكن المزايدة والبث المباشر تتطلب حسابًا.",
                      fontSize: 11.5,
                      color: AppColors.primary,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: CustomText(
                      text: "لاحقًا",
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: CustomText(
                      text: "تسجيل الدخول",
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}