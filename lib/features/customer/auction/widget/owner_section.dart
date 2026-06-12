import 'package:flutter/material.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/features/auth/widget/dialog_auth.dart';
 import 'package:sheep/features/conversation/chat_screen.dart';
import 'package:sheep/managment/auth/helper.dart';
 import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';

Widget buildOwnerSection(
  BuildContext context, {
  dynamic sellerName,
  dynamic sellerId,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: double.infinity),
      CustomText(
        text: "صاحب المزاد",
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text("", style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          CustomText(
            text: sellerName ?? "صاحب المنتج",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
                if(HelperAuth().getLogin()){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ChatScreen(
                        sellerId: sellerId,
                        entryType: ChatEntryType.fromProduct,
                        sellerName: sellerName ?? "",
                      ),
                ),
              );}else{
                showLoginRequiredDialog(
            context: context,
            onLogin: () {
               toRemoveAll(LoginScreen());
            },
          );
              }
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.chat,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
