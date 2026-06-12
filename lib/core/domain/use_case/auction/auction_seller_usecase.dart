import 'dart:io';

import 'package:sheep/core/data/response/auction/auction_seller_response.dart';
import 'package:sheep/core/domain/repo/auction/auction_seller_repo.dart';
import 'package:sheep/core/server/result.dart';

class AuctionSellerUsecase {
  AuctionSellerRepoImpl auctionSellerRepoImpl;
  AuctionSellerUsecase(this.auctionSellerRepoImpl);
  Future<ApiResult<Map<String, dynamic>>> addAuction({
    required Map<String, dynamic> dataAuction,
    List<File>? images,
  }) async {
    return await auctionSellerRepoImpl.addAuction(
      dataAuction: dataAuction,
      images: images,
    );
  }
   Future<ApiResult<AuctionSellerResponse>> getMyAuctions({
    required Map<String, dynamic> filter,
  })async{
    return await auctionSellerRepoImpl.getMyAuctions(
      filter: filter
    );
  }
}
