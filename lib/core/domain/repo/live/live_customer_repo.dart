import 'package:sheep/core/data/data_source/live/live_customer_data_source.dart';
import 'package:sheep/core/data/response/live/all_live_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class LiveCustomerRepo {
  Future<ApiResult<LiveResponse>> getAllLive({
    required Map<String, dynamic> query,
  });
}

class LiveCustomerRepoImpl extends LiveCustomerRepo {
  LiveCustomerDataSourceImpl liveCustomerDataSourceImpl;
  LiveCustomerRepoImpl(this.liveCustomerDataSourceImpl);
  @override
  Future<ApiResult<LiveResponse>> getAllLive({
    required Map<String, dynamic> query,
  }) async {
    final result = await liveCustomerDataSourceImpl.getAllLive(query: query);
    if (result.isFailed) {
      return ApiResult.failed(
        message: result.messageAsString,
        data: result.data,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(LiveResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }
}
