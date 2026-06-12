import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';
 
abstract class HomeSellerDataSource {
  Future<ApiResult<Map<String, dynamic>>> getDataSeller();
}

class HomeSellerDataSourceImpl extends HomeSellerDataSource {
  DioClient dioClient;
  HomeSellerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getDataSeller() async {
    return await dioClient.request(
      path: ApiService.sellerDetails,
      method: 'GET',
   
    );
  }
}
