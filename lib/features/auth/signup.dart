import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:sheep/features/auth/signup_seller.dart';
import 'package:sheep/managment/auth/auth_cubit.dart';
import 'package:sheep/managment/auth/auth_state.dart';
 import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/route.dart';
import 'package:sheep/util/widgets/custom_button.dart';
import 'package:sheep/util/widgets/custom_form_faild.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/auth/widget/terms_privacy.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/main.dart';
import 'package:sheep/util/widgets/custom_validation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    context.read<AuthCubit>().resetAll();
    super.initState();
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _key = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
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
                  arrowLift(context, AppStrings.signup),
                  SizedBox(height: hi * 0.01),
                  Divider(color: AppColors.border, thickness: 1),
                  SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ValidateWidget(
                      validator: (value) {
                        if (nameController.text.isEmpty) {
                          return AppStrings.requiredInput;
                        }
                        return null;
                      },
                      child: CustomTextFormField(
                        label: AppStrings.name,
                        hint: AppStrings.enter_name,
                        keyboardType: TextInputType.name,
                        controller: nameController,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
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
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ValidateWidget(
                      validator: (value) {
                        if (confirmPasswordController.text.isEmpty) {
                          return AppStrings.requiredInput;
                        } else if (confirmPasswordController.text !=
                            passwordController.text) {
                          return AppStrings.confirmPasswordNotEqual;
                        }
                        return null;
                      },
                      child: CustomTextFormField(
                        label: AppStrings.confirm_password,
                        hint: AppStrings.enter_confirm_password,
                        isPassword: true,
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TermsAndPrivacyText(
                      onPrivacyTap: () {},
                      onTermsTap: () {},
                    ),
                  ),
                  SizedBox(height: hi * 0.02),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      title:
                          state.registerStatus == AuthStatus.loading
                              ? true
                              : AppStrings.signup,
                      onTap: () {
                        if (_key.currentState!.validate()) {
  
                          context.read<AuthCubit>().signupFunction(
                            context,
                            phone: phoneController.text,
                            password: passwordController.text,
                            name: nameController.text,
                            userRole: UserRole.Customer,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: hi * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: AppStrings.have_account,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 5),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                          child: Center(
                            child: CustomText(
                              text: AppStrings.login,
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
                  // SizedBox(height: hi * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CustomButton(
                      colorButton: AppColors.secondary,
                      onTap: () {
                        To(context, SignupSellerScreen());
                      },
                      title: "التسجيل ك عضو",
                    ),
                  ),
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
