import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class CategoryDataSource {
  Future<ApiResult<Map<String, dynamic>>> getCategory({required int page});
  Future<ApiResult<Map<String, dynamic>>> getBreeds({required int page});

}

class CategoryDataSourceImpl extends CategoryDataSource {
  DioClient dioClient;
  CategoryDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getCategory({
    required int page,
  }) async {
    return await dioClient.request(
      path: ApiService.category,
      method: 'GET',
      queryParameters: {
        'PageNumber':page,
        'IsActive':true,
      },
    );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> getBreeds({required int page}) async{
  return await dioClient.request(
      path: ApiService.breeds,
      method: 'GET',
      queryParameters: {
        'PageNumber':page,
        'IsActive':true,
      },
    );
  }
}
