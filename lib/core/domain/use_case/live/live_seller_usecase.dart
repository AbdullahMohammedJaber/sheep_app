import 'package:sheep/core/domain/repo/live/live_seller_repo.dart';
import 'package:sheep/core/server/result.dart';

class LiveSellerUsecase {
  LiveSellerRepoImpl liveSellerRepoImpl;
  LiveSellerUsecase(this.liveSellerRepoImpl);

  Future<ApiResult<Map<String, dynamic>>> startLive({
    required String title,
    required String describtion,
  }) async {
    return await liveSellerRepoImpl.startLive(
      describtion: describtion,
      title: title,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getToken({
    required String channleName,
  }) async {
    return await liveSellerRepoImpl.getToken(channleName: channleName);
  }

  Future<ApiResult<Map<String, dynamic>>> endLive({required int id}) async {
    return await liveSellerRepoImpl.endLive(id: id);
  }
}
