import 'dart:io';

import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class ProductSellerDataSource {
  Future<ApiResult<Map<String, dynamic>>> addProduct({
    required Map<String, dynamic> dataForm,
    required List<File>? files,
  });
  Future<ApiResult<Map<String, dynamic>>> updateProduct({
    required Map<String, dynamic> dataForm,
    required List<File> files,
    required int id,
  });
  Future<ApiResult<Map<String, dynamic>>> deleteProduct({required dynamic id});
  Future<ApiResult<Map<String, dynamic>>> getMyProduct({
    required Map<String, dynamic> filter,
  });
  Future<ApiResult<Map<String, dynamic>>> detailsProduct({required dynamic id});
}

class ProductSellerDataSourceImpl extends ProductSellerDataSource {
  DioClient dioClient;
  ProductSellerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> addProduct({
    required Map<String, dynamic> dataForm,
    required List<File>? files,
  }) async {
    return await dioClient.request(
      path: ApiService.addProduct,
      method: 'POST',
      data: dataForm,
      files: files,
      isMultipart: true,
      fileFieldName: 'Images',
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getMyProduct({
    required Map<String, dynamic> filter,
  }) async {
    return await dioClient.request(
      path: ApiService.myProduct,
      method: 'GET',
      queryParameters: filter,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteProduct({
    required dynamic id,
  }) async {
    return await dioClient.request(
      path: ApiService.deleteProduct,
      method: 'POST',
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> detailsProduct({required id}) async {
    return await dioClient.request(
      path: ApiService.detailsProduct,
      method: 'GET',
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProduct({
    required Map<String, dynamic> dataForm,
    required List<File> files,
    required int id,
  }) async {
    return await dioClient.request(
      path: ApiService.updateProduct,
      method: 'POST',
      data: dataForm,
      files: files,
      isMultipart: files.isEmpty ? false : true,
      fileFieldName: 'new_Images',
      queryParameters: {'id': id},
    );
  }
}
