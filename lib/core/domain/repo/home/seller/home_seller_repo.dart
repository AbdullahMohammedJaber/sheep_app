import 'package:sheep/core/data/data_source/home/seller/home_seller_data_source.dart';
import 'package:sheep/core/data/response/home/data_seller_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class HomeSellerRepo {
  Future<ApiResult<DataSellerResponse>> getDataSeller();
}

class HomeSellerRepoImpl extends HomeSellerRepo {
  HomeSellerDataSourceImpl homeSellerDataSourceImpl;
  HomeSellerRepoImpl(this.homeSellerDataSourceImpl);
  @override
  Future<ApiResult<DataSellerResponse>> getDataSeller() async {
    final result = await homeSellerDataSourceImpl.getDataSeller();
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isNoInternet) {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    } else {
      return ApiResult.success(DataSellerResponse.fromJson(result.data!));
    }
  }
}
