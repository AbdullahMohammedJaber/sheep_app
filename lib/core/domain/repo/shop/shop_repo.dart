import 'package:sheep/core/data/data_source/shop/shop_data_source.dart';
import 'package:sheep/core/data/response/shop/shop_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class ShopRepo {
  Future<ApiResult<ShopsResponse>> getShops({
    required Map<String, dynamic> query,
  });
  Future<ApiResult<Map<String, dynamic>>> getShopDetails({
    required String sellerId,
  });
}

class ShopRepoImpl extends ShopRepo {
  ShopDataSourceImpl shopDataSourceImpl;
  ShopRepoImpl(this.shopDataSourceImpl);
  @override
  Future<ApiResult<ShopsResponse>> getShops({
    required Map<String, dynamic> query,
  }) async {
    final result = await shopDataSourceImpl.getShops(query: query);

    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(ShopsResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getShopDetails({
    required String sellerId,
  }) async {
    final result = await shopDataSourceImpl.getShopDetails(sellerId: sellerId);

    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(result.data!);
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
}
