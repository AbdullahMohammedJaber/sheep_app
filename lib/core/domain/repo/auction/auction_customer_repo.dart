import 'package:sheep/core/data/data_source/auction/auction_customer_data_source.dart';
import 'package:sheep/core/data/response/auction/auction_customer_response.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class AuctionCustomerRepo {
  Future<ApiResult<AuctionCustomerResponse>> getAuctions({
    Map<String, dynamic>? quary,
  });
  Future<ApiResult<DetailsAuctionsResponse>> getAuctionsDetails({
    required dynamic id,
  });
  Future<ApiResult<Map<String, dynamic>>> placeBid({
    required dynamic id,
    required dynamic amount,
  });
}

class AuctionCustomerRepoImpl extends AuctionCustomerRepo {
  AuctionCustomerDataSourceImpl auctionCustomerDataSourceImpl;
  AuctionCustomerRepoImpl(this.auctionCustomerDataSourceImpl);
  @override
  Future<ApiResult<AuctionCustomerResponse>> getAuctions({
    Map<String, dynamic>? quary,
  }) async {
    final result = await auctionCustomerDataSourceImpl.getAuctions(
      quary: quary,
    );

    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(AuctionCustomerResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }

  @override
  Future<ApiResult<DetailsAuctionsResponse>> getAuctionsDetails({
    required dynamic id,
  }) async {
    final result = await auctionCustomerDataSourceImpl.getDetailsAuctions(
      id: id,
    );

    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(DetailsAuctionsResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> placeBid({
    required id,
    required amount,
  }) async {
    final result = await auctionCustomerDataSourceImpl.placeBid(
      id: id,
      amount: amount,
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
