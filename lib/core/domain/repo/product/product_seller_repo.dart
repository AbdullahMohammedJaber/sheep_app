import 'dart:io';

import 'package:sheep/core/data/data_source/product/product_seller_data_source.dart';
import 'package:sheep/core/data/response/product/product_seller_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class ProductSellerRepo {
  Future<ApiResult<Map<String, dynamic>>> addProduct({
    required Map<String, dynamic> dataForm,
    required List<File>? files,
  });
  Future<ApiResult<Map<String, dynamic>>> updateProduct({
    required Map<String, dynamic> dataForm,
    required List<File>  files,
    required int id,
  });
  Future<ApiResult<ProductSellerResponse>> getMyProduct({
    required Map<String, dynamic> filter,
  });
  Future<ApiResult<Map<String, dynamic>>> deleteProduct({required dynamic id});
  Future<ApiResult<Map<String, dynamic>>> detailsProduct({required dynamic id});
}

class ProductSellerRepoImpl extends ProductSellerRepo {
  ProductSellerDataSourceImpl productSellerDataSourceImpl;
  ProductSellerRepoImpl(this.productSellerDataSourceImpl);
  @override
  Future<ApiResult<Map<String, dynamic>>> addProduct({
    required Map<String, dynamic> dataForm,
    required List<File>? files,
  }) async {
    final result = await productSellerDataSourceImpl.addProduct(
      dataForm: dataForm,
      files: files,
    );
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

  @override
  Future<ApiResult<ProductSellerResponse>> getMyProduct({
    required Map<String, dynamic> filter,
  }) async {
    final result = await productSellerDataSourceImpl.getMyProduct(
      filter: filter,
    );
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(ProductSellerResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteProduct({required id}) async {
    final result = await productSellerDataSourceImpl.deleteProduct(id: id);
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

  @override
  Future<ApiResult<Map<String, dynamic>>> detailsProduct({required id}) async {
    final result = await productSellerDataSourceImpl.detailsProduct(id: id);
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

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProduct({
    required Map<String, dynamic> dataForm,
    required List<File>  files,
    required int id,
  }) async {
    final result = await productSellerDataSourceImpl.updateProduct(
      dataForm: dataForm,
      files: files,
      id: id,
    );
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
