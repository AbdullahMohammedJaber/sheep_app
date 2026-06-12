import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/auth/widget/dialog_auth.dart';
import 'package:sheep/features/seller/home/analyze_data_widget.dart';
import 'package:sheep/features/seller/profile/section_image.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/util/constants/app_assets.dart';

import 'package:sheep/util/constants/app_colors.dart';

import 'package:sheep/features/customer/profile/profile_menue_item.dart';

import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class ProdileSellerScreen extends StatefulWidget {
  const ProdileSellerScreen({super.key});

  @override
  State<ProdileSellerScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProdileSellerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: hi * 0.04),

                SectionImageSeller(),
                SizedBox(height: hi * 0.02),
                if (context.read<HomeSellerCubit>().state.dataSellerResponse !=
                    null)
                  StoreData(),

                SizedBox(height: hi * 0.02),
                AnalyzeDataWidget(),
                SizedBox(height: hi * 0.02),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: AppAssets.privacy,
                        title: 'سياسة الخصوصية',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: AppAssets.aboutApp,

                        title: 'عن التطبيق',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: AppAssets.logout,

                        title: 'تسجيل الخروج',
                        onTap: () {
                          showLogoutDialog(
                            context: context,
                            onConfirm: () async {
                              await context.read<AuthCubit>().logoutUser();
                            },
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: AppAssets.delete,
                        iconColor: Color(0xffFF4B4B),
                        colotTitle: Color(0xffFF4B4B),
                        title: 'حذف الحساب',
                        onTap: () {
                           showLogoutDialog(
                            context: context,
                            onConfirm: () async {
                              await context.read<AuthCubit>().logoutUser();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoreData extends StatelessWidget {
  const StoreData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "معلومات المتجر",
              color: AppColors.secondary,
              fontSize: 12,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                SvgPicture.asset(AppAssets.phone),
                SizedBox(width: 3),
                CustomText(
                  text: "رقم الجوال : ",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                CustomText(
                  text:
                      "${context.read<HomeSellerCubit>().state.dataSellerResponse!.data!.phone}",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(height: 2),
    
            Row(
              children: [
                  SvgPicture.asset(AppAssets.store),
                SizedBox(width: 3),
                CustomText(
                  text: "اسم المتجر : ",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                CustomText(
                  text:
                      "${context.read<HomeSellerCubit>().state.dataSellerResponse!.data!.storeName}",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(height: 2),
    
            Row(
              children: [
                 SvgPicture.asset(AppAssets.location),
                SizedBox(width: 3),
                CustomText(
                  text: "الموقع : ",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                CustomText(
                  text:
                      "${context.read<HomeSellerCubit>().state.dataSellerResponse!.data!.storeAddress}",
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
