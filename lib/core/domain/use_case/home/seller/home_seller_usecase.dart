

import 'package:sheep/core/data/response/home/data_seller_response.dart';
import 'package:sheep/core/domain/repo/home/seller/home_seller_repo.dart';
import 'package:sheep/core/server/result.dart';

class HomeSellerUsecase {
  HomeSellerRepoImpl homeSellerRepoImpl;
  HomeSellerUsecase(this.homeSellerRepoImpl);
   Future<ApiResult<DataSellerResponse>> getDataSeller()async{
     return await homeSellerRepoImpl.getDataSeller();
   }
}