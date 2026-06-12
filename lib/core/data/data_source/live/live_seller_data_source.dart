import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class LiveSellerDataSource {
  Future<ApiResult<Map<String, dynamic>>> startLive({
    required String title,
    required String describtion,
  });
  Future<ApiResult<Map<String, dynamic>>> getToken({
    required String channleName,
  });
   Future<ApiResult<Map<String, dynamic>>> endLive({
    required int id,
  });
}

class LiveSellerDataSourceImpl extends LiveSellerDataSource {
  DioClient dioClient;
  LiveSellerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> startLive({
    required String title,
    required String describtion,
  }) async {
    return await dioClient.request(
      path: ApiService.startLive,
      method: 'POST',
      data: {"live_Name": title, "live_Description": describtion},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getToken({
    required String channleName,
  }) async {
    return await dioClient.request(
      path: ApiService.getToken,
      method: 'GET',
      queryParameters: {'channelName': channleName},
    );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> endLive({required int id}) async{
  return await dioClient.request(
      path: ApiService.endLive,
      method: 'POST',
      queryParameters: {'id': id},
    );
  }
}
