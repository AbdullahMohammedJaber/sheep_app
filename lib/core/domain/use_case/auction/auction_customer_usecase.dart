import 'package:sheep/core/data/response/auction/auction_customer_response.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/core/domain/repo/auction/auction_customer_repo.dart';
import 'package:sheep/core/server/result.dart';

class AuctionCustomerUsecase {
  AuctionCustomerRepoImpl auctionCustomerRepoImpl;
  AuctionCustomerUsecase(this.auctionCustomerRepoImpl);

  Future<ApiResult<AuctionCustomerResponse>> callGetAuctions({
    Map<String, dynamic>? query,
  }) async {
    return await auctionCustomerRepoImpl.getAuctions(quary: query);
  }

  Future<ApiResult<DetailsAuctionsResponse>> getAuctionsDetails({
    required dynamic id,
  }) async {
    return await auctionCustomerRepoImpl.getAuctionsDetails(id: id);
  }

  Future<ApiResult<Map<String, dynamic>>> placeBid({
    required dynamic id,
    required dynamic amount,
  }) async {
    return await auctionCustomerRepoImpl.placeBid(id: id, amount: amount);
  }
}
