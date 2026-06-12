import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/features/auth/widget/dialog_auth.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_assets.dart';

import 'package:sheep/util/constants/app_colors.dart';

import 'package:sheep/features/customer/profile/profile_menue_item.dart';

import 'package:sheep/features/customer/profile/section_image.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/route.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
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

                SectionImage(),

                SizedBox(height: hi * 0.05),

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
                        icon: AppAssets.lock,
                        title: 'تغيير كلمة المرور',
                        onTap: () {},
                      ),

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
                        icon: AppAssets.shareApp,

                        title: 'مشاركة التطبيق',
                        onTap: () {},
                      ),

                      ProfileMenuItem(
                        icon: AppAssets.logout,

                        title:
                            HelperAuth().getLogin()
                                ? 'تسجيل الخروج'
                                : "تسجيل الدخول",
                        onTap: () {
                          if (HelperAuth().getLogin()) {
                            showLogoutDialog(
                              context: context,
                              onConfirm: () async {
                                await context.read<AuthCubit>().logoutUser();
                              },
                            );
                          } else {
                            toRemoveAll(LoginScreen());
                          }
                        },
                      ),
                      HelperAuth().getLogin()?
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
                      ):SizedBox(),
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
