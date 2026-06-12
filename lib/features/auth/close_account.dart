import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class CloseAccountScreen extends StatefulWidget {
  const CloseAccountScreen({super.key});

  @override
  State<CloseAccountScreen> createState() => _CloseAccountScreenState();
}

class _CloseAccountScreenState extends State<CloseAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: SvgPicture.asset(AppAssets.arrowLeft)),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        AppAssets.timer,
                        color: AppColors.primary,
                        height: 80,
                      ),
                    ),
                    SizedBox(height: 5),
                    CustomText(
                      text: "حسابك قيد المراجعة",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 5),

                     CustomText(
                      text: "نشكرك على التسجيل في منصتنا. يتم حالياً مراجعة حسابك من قبل فريقنا وسيتم تفعيله خلال 24 ساعة.",
                      fontSize: 16,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
