 import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class ProductCustomerDataSource {
  Future<ApiResult<Map<String , dynamic>>> getProducts({
 
    Map<String, dynamic>? quary,
  });
}

class ProductCustomerDataSourceImpl extends ProductCustomerDataSource {
  DioClient dioClient;
  ProductCustomerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String , dynamic>>> getProducts({
   
    Map<String, dynamic>? quary,
  }) async {
    return dioClient.request(
      path: ApiService.products,
      method: 'GET',
      queryParameters: quary,
    );
  }
}
