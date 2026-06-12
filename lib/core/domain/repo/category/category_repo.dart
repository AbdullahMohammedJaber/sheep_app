import 'package:sheep/core/data/data_source/category/category_data_source.dart';
import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class CategoryRepo {
  Future<ApiResult<CategoryResponse>> getCategory({required int page});
  Future<ApiResult<BreedsResponse>> getBreeds({required int page});

}

class CategoryRepoImpl extends CategoryRepo {
  CategoryDataSourceImpl categoryDataSourceImpl;
  CategoryRepoImpl(this.categoryDataSourceImpl);
  @override
  Future<ApiResult<CategoryResponse>> getCategory({required int page}) async {
    final result = await categoryDataSourceImpl.getCategory(page: page);
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(CategoryResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
  
  @override
  Future<ApiResult<BreedsResponse>> getBreeds({required int page}) async {
    final result = await categoryDataSourceImpl.getBreeds(page: page);
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(BreedsResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
}
