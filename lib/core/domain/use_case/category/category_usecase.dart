import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/core/domain/repo/category/category_repo.dart';
import 'package:sheep/core/server/result.dart';

class CategoryUsecase {
  CategoryRepoImpl categoryRepoImpl;
  CategoryUsecase(this.categoryRepoImpl);

  Future<ApiResult<CategoryResponse>> getCategory({required int page}) async {
    return await categoryRepoImpl.getCategory(page: page);
  }

    Future<ApiResult<BreedsResponse>> getBreeds({required int page}) async {
    return await categoryRepoImpl.getBreeds(page: page);
  }
}
