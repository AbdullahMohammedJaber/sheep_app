import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/customer/root/root_customer_screen.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/auth/auth_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/auth/signup.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/custom_validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    context.read<AuthCubit>().resetAll();
    super.initState();
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: hi * 0.02),
                  arrowLift(context, AppStrings.login, canBack: false),
                  SizedBox(height: hi * 0.01),
                  Divider(color: AppColors.border, thickness: 1),
                  SizedBox(height: hi * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ValidateWidget(
                      validator: (value) {
                        if (phoneController.text.isEmpty) {
                          return AppStrings.requiredInput;
                        }
                        return null;
                      },
                      child: CustomTextFormField(
                        label: AppStrings.phone,
                        hint: AppStrings.enter_phone,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.02),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ValidateWidget(
                      validator: (value) {
                        if (passwordController.text.isEmpty) {
                          return AppStrings.requiredInput;
                        }
                        return null;
                      },
                      child: CustomTextFormField(
                        label: AppStrings.password,
                        hint: AppStrings.enter_password,
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            color: Colors.transparent,
                            child: Center(
                              child: CustomText(
                                text: AppStrings.forgetPassword,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hi * 0.02),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      title:
                          state.loginStatus == AuthStatus.loading
                              ? true
                              : AppStrings.login,
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          context.read<AuthCubit>().loginFunction(
                            phone: phoneController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      title: "تخطي",
                      colorButton: AppColors.secondary,

                      onTap: () {
                        toRemoveAll(RootCustomerScreen());
                      },
                    ),
                  ),
                  SizedBox(height: hi * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.dont_have_account,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 5),

                      GestureDetector(
                        onTap: () {
                          ToWithFade(context, SignupScreen());
                        },
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                          child: Center(
                            child: CustomText(
                              text: AppStrings.signup,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: hi * 0.02),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Divider(color: AppColors.border, thickness: 1),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 15),
                  //         child: CustomText(
                  //           text: AppStrings.or,
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w400,
                  //           color: AppColors.black,
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Divider(color: AppColors.border, thickness: 1),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: hi * 0.01),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {},
                  //       child: Container(
                  //         height: 50,
                  //         width: wi * 0.9,
                  //         decoration: BoxDecoration(
                  //           color: AppColors.white,
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(
                  //             color: AppColors.border,
                  //             width: 1,
                  //           ),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             CustomText(text: AppStrings.signin_google),
                  //             SizedBox(width: 10),
                  //             SvgPicture.asset(
                  //               AppAssets.google,
                  //               height: 24,
                  //               width: 24,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: hi * 0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
