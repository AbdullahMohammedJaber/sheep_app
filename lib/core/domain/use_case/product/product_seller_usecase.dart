import 'dart:io';

import 'package:sheep/core/data/response/product/product_seller_response.dart';
import 'package:sheep/core/domain/repo/product/product_seller_repo.dart';
import 'package:sheep/core/server/result.dart';

class ProductSellerUsecase {
  ProductSellerRepoImpl productSellerRepoImpl;
  ProductSellerUsecase(this.productSellerRepoImpl);
  Future<ApiResult<Map<String, dynamic>>> addProduct({
    required Map<String, dynamic> dataForm,
    required List<File>? files,
  }) async {
    return await productSellerRepoImpl.addProduct(
      dataForm: dataForm,
      files: files,
    );
  }

  Future<ApiResult<ProductSellerResponse>> getMyProduct({
    required Map<String, dynamic> filter,
  }) async {
    return await productSellerRepoImpl.getMyProduct(filter: filter);
  }

  Future<ApiResult<Map<String, dynamic>>> deleteProduct({
    required dynamic id,
  }) async {
    return await productSellerRepoImpl.deleteProduct(id: id);
  }

  Future<ApiResult<Map<String, dynamic>>> detailsProduct({
    required dynamic id,
  }) async {
    return await productSellerRepoImpl.detailsProduct(id: id);
  }

  Future<ApiResult<Map<String, dynamic>>> updateProduct({
    required Map<String, dynamic> dataForm,
    required List<File>  files,
    required int id,
  }) async {
    return await productSellerRepoImpl.updateProduct(
      dataForm: dataForm,
      files: files,
      id: id,
    );
  }
}
