import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class AuctionCustomerDataSource {
  Future<ApiResult<Map<String, dynamic>>> getAuctions({
    Map<String, dynamic>? quary,
  });
  Future<ApiResult<Map<String, dynamic>>> getDetailsAuctions({
    required dynamic id,
  });
   Future<ApiResult<Map<String, dynamic>>> placeBid({
    required dynamic id,
    required dynamic amount,

  });
}

class AuctionCustomerDataSourceImpl extends AuctionCustomerDataSource {
  DioClient dioClient;
  AuctionCustomerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getAuctions({
    Map<String, dynamic>? quary,
  }) async {
    return dioClient.request(
      path: ApiService.auctions,
      method: 'GET',
      queryParameters: quary,
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getDetailsAuctions({
    required dynamic id,
  }) async {
    return dioClient.request(
      path: ApiService.auctionsDetails,
      method: 'GET',
      queryParameters: {'id': id},
    );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> 
  placeBid({required id, required amount}) async{
     return dioClient.request(
      path: ApiService.placeBid,
      method: 'POST',
       data: {
        "auction_Id": id,
        "amount": amount,
      },
   
    );
  }
}
