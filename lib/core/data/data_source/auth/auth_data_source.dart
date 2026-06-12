import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class AuthDataSource {
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
  Future<ApiResult<Map<String, dynamic>>> forgetPassword({
    required String phone,
  });
  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String phone,
  });
}

class AuthDataSourceImpl extends AuthDataSource {
  DioClient dioClient;
  AuthDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> login({
    required Map<String, dynamic> data,
  }) async {
    return await dioClient.request(
      path: ApiService.login,
      method: 'POST',
      data: data,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> signup({
    required Map<String, dynamic> data,
  }) async {
    return await dioClient.request(
      path: ApiService.signup,
      method: 'POST',
      data: data,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> logout({
    required String refreshToken,
  }) async {
    return await dioClient.request(
      path: "${ApiService.logout}?RefreshToken=$refreshToken",
      method: 'POST',
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> vOtp({
    required String phone,
    required String code,
  }) async {
    return await dioClient.request(
      path: ApiService.vOtp,
      method: 'POST',
      data: {"phone": phone, "code": code},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String phone,
  }) async {
    return await dioClient.request(
      path: ApiService.resendCode,
      method: 'POST',
      data: {"phoneNumber": phone},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> forgetPassword({
    required String phone,
  }) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String phone,
  }) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
