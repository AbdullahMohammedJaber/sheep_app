import 'dart:io';

import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class AuctionSellerDataSource {
  Future<ApiResult<Map<String, dynamic>>> addAuction({
    required Map<String, dynamic> dataAuction,
    List<File> images,
  });
   Future<ApiResult<Map<String, dynamic>>> getMyAuctions({
    required Map<String, dynamic> filter,
  });

}

class AuctionSellerDataSourceImpl extends AuctionSellerDataSource {
  DioClient dioClient;
  AuctionSellerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> addAuction({
    required Map<String, dynamic> dataAuction,
    List<File>? images,
  }) async {
    return await dioClient.request(
      path: ApiService.addAuction, method: "POST" , 
      isMultipart: true, 
      data: dataAuction,
      files: images , 
      fileFieldName: "Images"
      
      );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> getMyAuctions
  ({required Map<String, dynamic> filter}) async{
   return await dioClient.request(
      path: ApiService.myAuction,
      method: 'GET',
      queryParameters: filter,
    );
  }
}
