import 'package:sheep/core/data/data_source/live/live_seller_data_source.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class LiveSellerRepo {
  Future<ApiResult<Map<String, dynamic>>> startLive({
  required String title,
    required String describtion,
  });
  Future<ApiResult<Map<String, dynamic>>> getToken({
    required String channleName,
  });
  Future<ApiResult<Map<String, dynamic>>> endLive({
    required int id,
  });
}

class LiveSellerRepoImpl extends LiveSellerRepo {
  LiveSellerDataSourceImpl liveSellerDataSourceImpl;
  LiveSellerRepoImpl(this.liveSellerDataSourceImpl);
  @override
  Future<ApiResult<Map<String, dynamic>>> getToken({
    required String channleName,
  }) async {
    final result = await liveSellerDataSourceImpl.getToken(
      channleName: channleName,
    );
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.success(result.data!);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> startLive({
   required String title,
    required String describtion,
  }) async {
    final result = await liveSellerDataSourceImpl.startLive(
      title: title , describtion: describtion
    );
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.success(result.data!);
    }
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> endLive({required int id})async {
    final result = await liveSellerDataSourceImpl.endLive(
      id: id
    );
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.success(result.data!);
    }
  }
}

 