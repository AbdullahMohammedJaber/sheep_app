import 'package:sheep/core/data/response/live/all_live_response.dart';
import 'package:sheep/core/domain/repo/live/live_customer_repo.dart';
import 'package:sheep/core/server/result.dart';

class LiveCustomerUsecase {
  LiveCustomerRepoImpl liveCustomerRepoImpl;
  LiveCustomerUsecase(this.liveCustomerRepoImpl);
  Future<ApiResult<LiveResponse>> getAllLive({
    required Map<String, dynamic> query,
  }) async {
    return await liveCustomerRepoImpl.getAllLive(query: query);
  }
}
