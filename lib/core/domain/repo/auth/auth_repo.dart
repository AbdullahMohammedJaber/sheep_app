import 'package:sheep/core/data/data_source/auth/auth_data_source.dart';
import 'package:sheep/core/server/result.dart';

import 'package:sheep/util/constants/app_strings.dart';

abstract class AuthRepo {
  Future<ApiResult<Map<String, dynamic>>> login({
    required Map<String, dynamic> data,
  });
  Future<ApiResult<Map<String, dynamic>>> signup({
    required Map<String, dynamic> data,
  });
  Future<ApiResult<Map<String, dynamic>>> logout({
    required String refreshToken,
  });
  Future<ApiResult<Map<String, dynamic>>> vOtp({
    required String phone,
    required String code,
  });
  Future<ApiResult<Map<String, dynamic>>> resendCode({required String phone});
}

class AuthRepoImpl extends AuthRepo {
  AuthDataSourceImpl authDataSourceImpl;
  AuthRepoImpl(this.authDataSourceImpl);
  @override
  Future<ApiResult<Map<String, dynamic>>> login({
    required Map<String, dynamic> data,
  }) async {
    final result = await authDataSourceImpl.login(data: data);

    if (result.isSuccess) {
      return ApiResult.success(
        result.data!,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.failed(
        message: result.messageAsString,
        statusCode: result.data!['statusCode'],
        data: result.data,
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> signup({
    required Map<String, dynamic> data,
  }) async {
    final result = await authDataSourceImpl.signup(data: data);
    if (result.isSuccess) {
      return ApiResult.success(
        result.data!,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.failed(
        message: result.messageAsString,
        statusCode: result.statusCode,
        data: result.data,
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> logout({
    required String refreshToken,
  }) async {
    final result = await authDataSourceImpl.logout(refreshToken: refreshToken);
    if (result.isSuccess) {
      return ApiResult.success(
        result.data!,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.failed(
        message: result.messageAsString,
        statusCode: result.statusCode,
        data: result.data,
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> vOtp({
    required String phone,
    required String code,
  }) async {
    final result = await authDataSourceImpl.vOtp(code: code, phone: phone);
    if (result.isSuccess) {
      return ApiResult.success(
        result.data!,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.failed(
        message: result.messageAsString,
        statusCode: result.statusCode,
        data: result.data,
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String phone,
  }) async {
    final result = await authDataSourceImpl.resendCode(phone: phone);
    if (result.isSuccess) {
      return ApiResult.success(
        result.data!,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.failed(
        message: result.messageAsString,
        statusCode: result.statusCode,
        data: result.data,
      );
    }
  }
}
