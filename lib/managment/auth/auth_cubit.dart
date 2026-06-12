import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/auth/user_response.dart';
import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/features/auth/close_account.dart';
import 'package:sheep/features/auth/login.dart';
import 'package:sheep/features/auth/v_otp.dart';
import 'package:sheep/features/customer/root/root_customer_screen.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/NavigatorObserver/Navigator_observe.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/fcm/fcm.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void selectVendorType(UserRole type) {
    emit(state.copyWith(userRole: type));
  }

  Future<void> loginFunction({
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(loginStatus: AuthStatus.loading, errorMessage: null));

    try {
      final result = await UserCaseState().authUserCase.callLogin(
        data: {"phone_Number": phone, "password": password},
      );

      result.handle(
        onSuccess: (data) {
          showMessage("تم تسجيل الدخول بنجاح", value: true);
          UserResponse user = UserResponse.fromJson(result.data!);
          HelperAuth().loginUser(user);
          emit(state.copyWith(loginStatus: AuthStatus.success));
          if (user.data!.isverify!) {
            if (HelperAuth().getUser()!.data!.role == UserRole.Customer.name) {
              toRemoveAll(RootCustomerScreen());
            } else {
              toRemoveAll(RootSellerScreen());
            }
          } else {
            ToWithFade(
              NavigationService.navigatorKey.currentContext!,
              CloseAccountScreen(),
            );
          }
          updateFcmToken();
        },
        onFailed: (message, code) {
          emit(
            state.copyWith(
              loginStatus: AuthStatus.error,
              errorMessage: message,
            ),
          );
          showMessage(message, value: false);
          if (code == 401) {
            resendCodeOtp(phone: phone, goLogin: true);
          }
        },
        onNoInternet: () {
          showMessage(AppStrings.noInternet, value: false);
          emit(
            state.copyWith(
              loginStatus: AuthStatus.error,
              errorMessage: AppStrings.noInternet,
            ),
          );
        },
      );
    } catch (e) {
      showMessage(AppStrings.noInternet, value: false);
      emit(
        state.copyWith(
          loginStatus: AuthStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> signupFunction(
    BuildContext context, {
    required String phone,
    required String password,
    required String name,
    required UserRole userRole,
  }) async {
    emit(
      state.copyWith(registerStatus: AuthStatus.loading, errorMessage: null),
    );

    final result = await UserCaseState().authUserCase.callsignup(
      data: {
        "phoneNumber": phone,
        "password": password,
        "fullName": name,
        "roleName": userRole.name,
      },
    );

    result.handle(
      onSuccess: (data) {
        showMessage(data['data'], value: true);
        emit(
          state.copyWith(
            registerStatus: AuthStatus.success,
            errorMessage: data['message'],
          ),
        );
        ToRemove(context, VOtpScreen(phone: phone));
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            registerStatus: AuthStatus.error,
            errorMessage: message,
          ),
        );
        showMessage(message, value: false);
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);

        emit(
          state.copyWith(
            registerStatus: AuthStatus.error,
            errorMessage: AppStrings.noInternet,
          ),
        );
      },
    );
  }

  Future<void> logoutUser() async {
    try {
      showBoatToast();
      final result = await UserCaseState().authUserCase.calllogout(
        refreshToken: HelperAuth().getUser()!.data!.refreshToken!,
      );
      closeAllLoading();
      result.handle(
        onSuccess: (data) {
          showMessage(data['data'], value: true);
          HelperAuth().logoutUser();
          toRemoveAll(LoginScreen());
        },
        onFailed: (message, code) {
          showMessage(message, value: false);
        },
        onNoInternet: () {
          showMessage(result.messageAsString, value: false);
        },
      );
    } catch (e) {
      closeAllLoading();
    }
  }

  Future<void> vOtp({required String phone, required String code}) async {
    emit(state.copyWith(verifyCodeStatus: AuthStatus.loading));
    final result = await UserCaseState().authUserCase.callVotp(
      code: code,
      phone: phone,
    );
    emit(state.copyWith(verifyCodeStatus: AuthStatus.initial));
    result.handle(
      onSuccess: (data) {
        showMessage("تم تأكيد الحساب الرجاء تسجيل الدخول", value: true);
        toRemoveAll(LoginScreen());
      },
      onFailed: (message, code) {
        showMessage(message, value: false);
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }

  Future<void> resendCodeOtp({
    required String phone,
    bool goLogin = false,
  }) async {
    showBoatToast();
    final result = await UserCaseState().authUserCase.callResendCode(
      phone: phone,
    );
    closeAllLoading();
    result.handle(
      onSuccess: (data) {
        showMessage(data['data'], value: true);
        if (goLogin) {
          ToWithFade(
            NavigationService.navigatorKey.currentContext!,
            VOtpScreen(phone: phone),
          );
        }
      },
      onFailed: (message, code) {
        showMessage(message, value: false);
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }

  updateFcmToken() async {
    final result = await DioClient().request(
      method: 'POST',
      path: 'Notifications/SaveToken',
      data: {
        "deviceToken": token,
        "platform": Platform.isAndroid ? "Android" : "iOS",
      },
    );

    result.handle(
      onSuccess: (data) {},
      onFailed: (message, code) {},
      onNoInternet: () {},
    );
  }

  void resetAll() {
    emit(const AuthState());
  }
}
