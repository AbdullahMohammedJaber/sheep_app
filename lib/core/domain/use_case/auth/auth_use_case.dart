import 'package:sheep/core/domain/repo/auth/auth_repo.dart';
import 'package:sheep/core/server/result.dart';

class AuthUseCase {
  AuthRepoImpl authRepoImpl;
  AuthUseCase(this.authRepoImpl);

  Future<ApiResult<Map<String, dynamic>>> callLogin({
    required Map<String, dynamic> data,
  }) async {
    return await authRepoImpl.login(data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> callsignup({
    required Map<String, dynamic> data,
  }) async {
    return await authRepoImpl.signup(data: data);
  }

  Future<ApiResult<Map<String, dynamic>>> calllogout({
    required String refreshToken,
  }) async {
    return await authRepoImpl.logout(refreshToken: refreshToken);
  }

  Future<ApiResult<Map<String, dynamic>>> callVotp({
    required String phone,
    required String code,
  }) async {
    return await authRepoImpl.vOtp(code: code, phone: phone);
  }

  Future<ApiResult<Map<String, dynamic>>> callResendCode({
    required String phone,
  }) async {
    return await authRepoImpl.resendCode(phone: phone);
  }
}
