import 'package:sheep/core/data/response/chat/chat_response.dart';
import 'package:sheep/core/data/response/chat/conversation_response.dart';
import 'package:sheep/core/domain/repo/chat/chat_repo.dart';
import 'package:sheep/core/server/result.dart';

class ChatUsecase {
  ChatRepoImpl chatRepoImpl;
  ChatUsecase(this.chatRepoImpl);
  Future<ApiResult<ConversationResponse>> getConversation() async {
    return await chatRepoImpl.getConversation();
  }

  Future<ApiResult<Map<String, dynamic>>> startChat({
    required int idSeller,
  }) async {
    return await chatRepoImpl.startChat(idSeller: idSeller);
  }

  Future<ApiResult<Map<String, dynamic>>> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    return await chatRepoImpl.sendMessage(
      conversationId: conversationId,
      message: message,
    );
  }
  Future<ApiResult<ChatResponse>> getMessages({required int conversationId}) async {
    return await chatRepoImpl.getMessages(conversationId: conversationId);
  }
}
