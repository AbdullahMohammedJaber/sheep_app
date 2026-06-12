import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class LiveCustomerDataSource {
  Future<ApiResult<Map<String, dynamic>>> getAllLive({
    required Map<String, dynamic> query,
  });
}

class LiveCustomerDataSourceImpl extends LiveCustomerDataSource {
  DioClient dioClient;
  LiveCustomerDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getAllLive({
    required Map<String, dynamic> query,
  }) async {
    return await dioClient.request(
      path: ApiService.getLives,
      method: 'GET',
      queryParameters: query,
    );
  }
}
