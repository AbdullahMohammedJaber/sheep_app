import 'package:sheep/core/data/response/shop/shop_response.dart';
import 'package:sheep/core/domain/repo/shop/shop_repo.dart';
import 'package:sheep/core/server/result.dart';

class ShopUsecase {
  ShopRepoImpl shopRepoImpl;
  ShopUsecase(this.shopRepoImpl);
  Future<ApiResult<ShopsResponse>> getShops({
    required Map<String, dynamic> query,
  }) async {
    return await shopRepoImpl.getShops(query: query);
  }

  Future<ApiResult<Map<String, dynamic>>> getShopDetails({
    required String sellerId,
  }) async {
    return await shopRepoImpl.getShopDetails(sellerId: sellerId);
  }
}
