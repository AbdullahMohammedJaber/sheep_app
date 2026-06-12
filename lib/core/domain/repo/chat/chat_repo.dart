import 'package:sheep/core/data/data_source/chat/chat_data_source.dart';
import 'package:sheep/core/data/response/chat/chat_response.dart';
import 'package:sheep/core/data/response/chat/conversation_response.dart';
import 'package:sheep/core/server/result.dart';
import 'package:sheep/util/constants/app_strings.dart';

abstract class ChatRepo {
  Future<ApiResult<ConversationResponse>> getConversation();
  Future<ApiResult<ChatResponse>> getMessages({required int conversationId});

  Future<ApiResult<Map<String, dynamic>>> startChat({required int idSeller});
  Future<ApiResult<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String message,
  });
}

class ChatRepoImpl extends ChatRepo {
  ChatDataSourceImpl chatDataSourceImpl;
  ChatRepoImpl(this.chatDataSourceImpl);
  @override
  Future<ApiResult<ConversationResponse>> getConversation() async {
    final result = await chatDataSourceImpl.getConversation();
    if (result.isFailed) {
      return ApiResult.failed(
        data: result.data,
        message: result.messageAsString,
        statusCode: result.statusCode,
      );
    } else if (result.isSuccess) {
      return ApiResult.success(ConversationResponse.fromJson(result.data!));
    } else {
      return ApiResult.noInternet(message: AppStrings.noInternet);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    final result = await chatDataSourceImpl.sendMessage(
      conversationId: conversationId,
      message: message,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> startChat({
    required int idSeller,
  }) async {
    final result = await chatDataSourceImpl.startChat(idSeller: idSeller);
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

  @override
  Future<ApiResult<ChatResponse>> getMessages({required int conversationId}) {
    return chatDataSourceImpl.getMessages(conversationId: conversationId).then((
      result,
    ) {
      if (result.isFailed) {
        return ApiResult.failed(
          data: result.data,
          message: result.messageAsString,
          statusCode: result.statusCode,
        );
      } else if (result.isSuccess) {
        return ApiResult.success(ChatResponse.fromJson(result.data!));
      } else {
        return ApiResult.noInternet(message: AppStrings.noInternet);
      }
    });
  }
}
