// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/auth/auth_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_text.dart';

class VOtpScreen extends StatefulWidget {
  final String phone;
  const VOtpScreen({super.key, required this.phone});

  @override
  State<VOtpScreen> createState() => _VOtpScreenState();
}

class _VOtpScreenState extends State<VOtpScreen> {
  final focusNode = FocusNode();

  final pinInputController = TextEditingController();
  late Timer timer;
  dynamic remainingTime = 59;
  startTimer() {
    remainingTime = 59;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,

      padding: const EdgeInsets.symmetric(horizontal: 15),
      textStyle: TextStyle(fontSize: 18, color: AppColors.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
        border: Border.all(color: AppColors.textSecondary),
      ),
    );
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: SingleChildScrollView(
            child: Column(
              children: [
                arrowLift(context, AppStrings.login_whatsapp),
                SizedBox(height: hi * 0.01),
                Divider(color: AppColors.border, thickness: 1),
                SizedBox(height: hi * 0.02),
                Center(
                  child: CustomText(
                    text: AppStrings.enter_otp,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: hi * 0.04),

                Center(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinInputController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      keyboardType: TextInputType.number,

                      validator: (value) {
                        return value!.isEmpty || value.length < 6
                            ? 'Pin is incorrect'
                            : null;
                      },
                      hapticFeedbackType: HapticFeedbackType.vibrate,
                      onCompleted: (pin) {
                        pinInputController.text = pin;
                        setState(() {});
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 15,
                            height: 1,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withOpacity(0.4),
                          border: Border.all(color: AppColors.primary),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                          border: Border.all(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: wi, height: hi * 0.02),
                Center(
                  child: CustomText(
                    text:
                        "00:${remainingTime < 10 ? "0${remainingTime.toString()}" : remainingTime.toString()}",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                remainingTime == 0
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Code not received ?",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 2),
                        GestureDetector(
                          onTap: () async {
                            pinInputController.clear();
                            context.read<AuthCubit>().resendCodeOtp(phone: widget.phone , goLogin: false);
                            startTimer();
                          },
                          child: CustomText(
                            text: "Resend",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    )
                    : const SizedBox(),
                SizedBox(width: wi, height: hi * 0.1),
                pinInputController.text.isEmpty
                    ? const SizedBox()
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: CustomButton(
                        title:
                            state.verifyCodeStatus == AuthStatus.loading
                                ? true
                                : "إرسال",

                        sizeTitle: 16,
                        colorButton: AppColors.primary,
                        onTap: () {
                          context.read<AuthCubit>().vOtp(
                            phone: widget.phone,
                            code: pinInputController.text,
                          );
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
