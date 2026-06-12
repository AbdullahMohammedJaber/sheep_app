import 'dart:io';

import 'package:sheep/core/data/data_source/auction/auction_seller_data_source.dart';
import 'package:sheep/core/data/response/auction/auction_seller_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class AuctionSellerRepo {
  Future<ApiResult<Map<String, dynamic>>> addAuction({
    required Map<String, dynamic> dataAuction,
    List<File> images,
  });
  Future<ApiResult<AuctionSellerResponse>> getMyAuctions({
    required Map<String, dynamic> filter,
  });
}

class AuctionSellerRepoImpl extends AuctionSellerRepo {
  AuctionSellerDataSourceImpl auctionSellerDataSourceImpl;
  AuctionSellerRepoImpl(this.auctionSellerDataSourceImpl);
  @override
  Future<ApiResult<Map<String, dynamic>>> addAuction({
    required Map<String, dynamic> dataAuction,
    List<File>? images,
  }) async {
    final result = await auctionSellerDataSourceImpl.addAuction(
      dataAuction: dataAuction,
      images: images,
    );
    if (result.isFailed) {
      return ApiResult.failed(
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
  Future<ApiResult<AuctionSellerResponse>> getMyAuctions({
    required Map<String, dynamic> filter,
  }) async {
    final result = await auctionSellerDataSourceImpl.getMyAuctions(
      filter: filter,
    );
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(AuctionSellerResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
}
