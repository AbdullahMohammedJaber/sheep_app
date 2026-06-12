import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class ShopDataSource {
  Future<ApiResult<Map<String, dynamic>>> getShops({
    required Map<String, dynamic> query,
  });
  Future<ApiResult<Map<String, dynamic>>> getShopDetails({
    required String sellerId,
  });
}

class ShopDataSourceImpl extends ShopDataSource {
  DioClient dioClient;
  ShopDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getShops({
    required Map<String, dynamic> query,
  }) async {
    return dioClient.request(
      path: ApiService.allShops,
      method: 'GET',
      queryParameters: query,
    );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> getShopDetails
  ({required String sellerId}) async{
    return dioClient.request(
      path: 'Users/GetSellerDetails?sellerId=$sellerId',
      method: 'GET',
    );

  }
      
}
