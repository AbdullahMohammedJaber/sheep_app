// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/features/customer/root/root_customer_screen.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late AnimationController _loadingController;
  late AnimationController _bottomController;
  late AnimationController _pulseController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoSlideAnimation;

  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  late Animation<double> _loadingFadeAnimation;
  late Animation<double> _loadingScaleAnimation;

  late Animation<double> _bottomFadeAnimation;
  late Animation<Offset> _bottomSlideAnimation;

  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    Future.delayed(Duration(seconds: 4), () {
      if (HelperAuth().getLogin()) {
        if (HelperAuth().getUser()!.data!.role == UserRole.Customer.name) {
          toRemoveAll(RootCustomerScreen());
        } else {
          toRemoveAll(RootSellerScreen());
        }
      } else {
        toRemoveAll(LoginScreen());
      }
    });
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Content animations
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    // Loading animations
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeIn),
    );

    _loadingScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeOut),
    );

    // Bottom animations
    _bottomController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bottomFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bottomController, curve: Curves.easeIn));

    _bottomSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeOutCubic),
    );

    // Pulse animation for commission container
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _logoController.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _contentController.forward();
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      _loadingController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _bottomController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _loadingController.dispose();
    _bottomController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hi = MediaQuery.of(context).size.height;
    wi = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SlideTransition(
                position: _logoSlideAnimation,
                child: FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(AppAssets.logo),
                        ),
                        SizedBox(height: hi * 0.02),
                        SlideTransition(
                          position: _contentSlideAnimation,
                          child: FadeTransition(
                            opacity: _contentFadeAnimation,
                            child: Column(
                              children: [
                                CustomText(
                                  text: "سوق الغنم",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.black,
                                ),
                                SizedBox(height: hi * 0.008),
                                CustomText(
                                  text: "www.الغنم.com | www.sheep.market",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading Section with animations
              FadeTransition(
                opacity: _loadingFadeAnimation,
                child: ScaleTransition(
                  scale: _loadingScaleAnimation,
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 2 * 3.14159,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: SvgPicture.asset(AppAssets.sheepIcon),
                        ),
                      ),
                      SizedBox(height: hi * 0.02),
                      CustomText(
                        text: "جاري التحميل",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: hi * 0.01),
                      // Loading indicator
                      SizedBox(
                        width: wi * 0.3,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Section with animations
              SlideTransition(
                position: _bottomSlideAnimation,
                child: FadeTransition(
                  opacity: _bottomFadeAnimation,
                  child: Column(
                    children: [
                      CustomText(
                        text: "الغنم بركة",
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                      SizedBox(height: hi * 0.01),
                      CustomText(
                        text: "سيدنا محمد ﷺ",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: hi * 0.03),
                      // Animated commission container
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              height: hi * 0.07,
                              width: wi * 0.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.2),
                                    AppColors.primary.withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: CustomText(
                                  text: ". %  عمولة البيع",
                                  textAlign: TextAlign.center,
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
