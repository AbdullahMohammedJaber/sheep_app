import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/core/server/servise.dart';

abstract class ChatDataSource {
  Future<ApiResult<Map<String, dynamic>>> getConversation();
  Future<ApiResult<Map<String, dynamic>>> getMessages({required int conversationId});

  Future<ApiResult<Map<String, dynamic>>> startChat({required int idSeller});
  Future<ApiResult<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String message,
  });
}

class ChatDataSourceImpl extends ChatDataSource {
  DioClient dioClient;
  ChatDataSourceImpl(this.dioClient);
  @override
  Future<ApiResult<Map<String, dynamic>>> getConversation() async {
    return await dioClient.request(
      path: ApiService.conversation,
      method: 'GET',
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> startChat({
    required int idSeller,
  }) async {
    return await dioClient.request(
      path: ApiService.startChat,
      method: 'POST',
      queryParameters: {'sellerId': idSeller},
    );
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    return await dioClient.request(
      path: ApiService.sendMessage,
      method: 'POST',
      data: {'conversation_Id': conversationId, 'message': message},
    );
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> getMessages({required int conversationId}) async{
     return await dioClient.request(
      path: 'Chat/GetMessages',
      method: 'GET',
      queryParameters: {'conversationId': conversationId},
    );
    
  }
}
