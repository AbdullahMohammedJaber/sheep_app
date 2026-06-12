import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/chat/chat_response.dart';
import 'package:sheep/core/data/response/chat/conversation_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/util/constants/app_strings.dart';

import 'chat_hub_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._chatHubService) : super(const ChatState());

  final ChatHubService _chatHubService;

  bool _loadingConversations = false;
  bool _loadingMessages = false;
  bool _startingConversation = false;

  StreamSubscription<ChatItemResponse>? _hubMessagesSubscription;

  String? _hubBaseUrl;

  String get _currentUserId =>
      HelperAuth().getUser()?.data?.userId?.toString() ?? '';

  Future<void> fetchChats() async {
    if (_loadingConversations) return;

    _loadingConversations = true;

    emit(
      state.copyWith(
        conversationsStatus: RequestStatus.loading,
        clearError: true,
      ),
    );

    final result = await UserCaseState().chatUserCase.getConversation();

    result.handle(
      onSuccess: (data) {
        final List<ConversationItemResponse> items = data.data ?? [];

        emit(
          state.copyWith(
            conversationsStatus: RequestStatus.success,
            conversations: items,
            clearError: true,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            conversationsStatus: RequestStatus.failure,
            error: message,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            conversationsStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );
      },
    );

    _loadingConversations = false;
  }

  Future<void> refreshChats() async {
    await fetchChats();
  }

  Future<void> startConversation({
    required int sellerId,
  }) async {
    if (_startingConversation) return;

    _startingConversation = true;

    emit(
      state.copyWith(
        startConversationStatus: RequestStatus.loading,
        clearError: true,
      ),
    );

    final result =
        await UserCaseState().chatUserCase.startChat(idSeller: sellerId);

    result.handle(
      onSuccess: (data) {
        final int? conversationId = int.tryParse(data['data'].toString());

        emit(
          state.copyWith(
            startConversationStatus: RequestStatus.success,
            currentConversationId: conversationId,
            clearError: true,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            startConversationStatus: RequestStatus.failure,
            error: message,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            startConversationStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );
      },
    );

    _startingConversation = false;
  }

  Future<void> fetchMessages({
    required int conversationId,
  }) async {
    if (_loadingMessages) return;

    _loadingMessages = true;

    emit(
      state.copyWith(
        messagesStatus: RequestStatus.loading,
        currentConversationId: conversationId,
        clearError: true,
      ),
    );

    final result = await UserCaseState().chatUserCase.getMessages(
      conversationId: conversationId,
    );

    result.handle(
      onSuccess: (data) {
        final items = (data.data ?? [])
            .map((e) => _mapBackendMessageToUi(e))
            .toList();

        emit(
          state.copyWith(
            messagesStatus: RequestStatus.success,
            currentConversationId: conversationId,
            messages: items,
            clearError: true,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            messagesStatus: RequestStatus.failure,
            error: message,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            messagesStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );
      },
    );

    _loadingMessages = false;
  }

  Future<void> refreshMessages() async {
    if (state.currentConversationId == null) return;
    await fetchMessages(conversationId: state.currentConversationId!);
  }

  Future<void> initChat({
    required int sellerId,
    required String hubBaseUrl,
    String receiveEventName = ChatHubService.defaultReceiveEventName,
  }) async {
    _hubBaseUrl = hubBaseUrl;

    await resetActiveChat();

    await startConversation(sellerId: sellerId);

    final conversationId = state.currentConversationId;
    if (conversationId == null) return;

    await fetchMessages(conversationId: conversationId);

    if (state.messagesStatus == RequestStatus.success) {
      await connectToChatHub(
        conversationId: conversationId,
        receiveEventName: receiveEventName,
      );
    }
  }

  Future<void> openExistingConversation({
    required int conversationId,
    required String hubBaseUrl,
    String receiveEventName = ChatHubService.defaultReceiveEventName,
  }) async {
    _hubBaseUrl = hubBaseUrl;

    await resetActiveChat();

    emit(
      state.copyWith(
        currentConversationId: conversationId,
        clearError: true,
        clearHubError: true,
      ),
    );

    await fetchMessages(conversationId: conversationId);

    if (state.messagesStatus == RequestStatus.success) {
      await connectToChatHub(
        conversationId: conversationId,
        receiveEventName: receiveEventName,
      );
    }
  }

  Future<void> retryConnectHub({
    String receiveEventName = ChatHubService.defaultReceiveEventName,
  }) async {
    final conversationId = state.currentConversationId;
    if (conversationId == null) return;

    await connectToChatHub(
      conversationId: conversationId,
      receiveEventName: receiveEventName,
    );
  }

  Future<void> connectToChatHub({
    required int conversationId,
    String receiveEventName = ChatHubService.defaultReceiveEventName,
    String? accessToken,
  }) async {
    if (_hubBaseUrl == null || _hubBaseUrl!.isEmpty) return;

    await disconnectChatHub(emitState: false);

    emit(
      state.copyWith(
        hubStatus: HubConnectionStatus.connecting,
        isHubConnected: false,
        clearHubError: true,
      ),
    );

    try {
      await _chatHubService.connect(
        baseUrl: _hubBaseUrl!,
        conversationId: conversationId,
        receiveEventName: receiveEventName,
        accessToken: accessToken,
      );

      _hubMessagesSubscription = _chatHubService.messagesStream.listen((message) {
        final incoming = _mapBackendMessageToUi(message);
        final updated = List<ChatUiMessage>.from(state.messages);

        final existingServerIndex = updated.indexWhere(
          (e) =>
              e.serverId != null &&
              incoming.serverId != null &&
              e.serverId == incoming.serverId,
        );

        if (existingServerIndex != -1) {
          return;
        }

        if (incoming.isMine) {
          final optimisticIndex = updated.lastIndexWhere(
            (e) =>
                e.isMine &&
                e.serverId == null &&
                e.text.trim() == incoming.text.trim() &&
                e.createdAt.difference(incoming.createdAt).inMinutes.abs() <= 2,
          );

          if (optimisticIndex != -1) {
            updated[optimisticIndex] = updated[optimisticIndex].copyWith(
              serverId: incoming.serverId,
              createdAt: incoming.createdAt,
              deliveryStatus: ChatMessageDeliveryStatus.sent,
            );

            emit(
              state.copyWith(
                messages: updated,
                isHubConnected: true,
                hubStatus: HubConnectionStatus.connected,
                clearHubError: true,
              ),
            );
            return;
          }
        }

        updated.add(incoming);

        emit(
          state.copyWith(
            messages: updated,
            isHubConnected: true,
            hubStatus: HubConnectionStatus.connected,
            clearHubError: true,
          ),
        );
      });

      emit(
        state.copyWith(
          isHubConnected: true,
          hubStatus: HubConnectionStatus.connected,
          clearHubError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isHubConnected: false,
          hubStatus: HubConnectionStatus.failure,
          hubError: e.toString(),
        ),
      );
    }
  }

  Future<void> disconnectChatHub({bool emitState = true}) async {
    try {
      await _hubMessagesSubscription?.cancel();
      _hubMessagesSubscription = null;

      await _chatHubService.disconnect();

      if (emitState) {
        emit(
          state.copyWith(
            isHubConnected: false,
            hubStatus: HubConnectionStatus.initial,
            clearHubError: true,
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> resetActiveChat() async {
    await disconnectChatHub(emitState: false);

    emit(
      state.copyWith(
        messagesStatus: RequestStatus.initial,
        startConversationStatus: RequestStatus.initial,
        hubStatus: HubConnectionStatus.initial,
        clearConversationId: true,
        clearMessages: true,
        currentMessage: '',
        isHubConnected: false,
        clearError: true,
        clearHubError: true,
      ),
    );
  }

  void onMessageChanged(String value) {
    emit(
      state.copyWith(
        currentMessage: value,
        clearError: true,
      ),
    );
  }

  void clearError() {
    emit(
      state.copyWith(
        clearError: true,
      ),
    );
  }

  void clearHubError() {
    emit(
      state.copyWith(
        clearHubError: true,
      ),
    );
  }

  Future<void> sendMessage() async {
    if (!state.canSend) return;
    if (state.currentConversationId == null) return;

    final text = state.currentMessage.trim();
    if (text.isEmpty) return;

    final localId = DateTime.now().microsecondsSinceEpoch.toString();

    final optimisticMessage = ChatUiMessage(
      localId: localId,
      serverId: null,
      senderId: _currentUserId,
      text: text,
      createdAt: DateTime.now(),
      isMine: true,
      deliveryStatus: ChatMessageDeliveryStatus.sending,
    );

    emit(
      state.copyWith(
        messages: [...state.messages, optimisticMessage],
        currentMessage: '',
        clearError: true,
      ),
    );

    final result = await UserCaseState().chatUserCase.sendMessage(
      conversationId: state.currentConversationId!,
      message: text,
    );

    result.handle(
      onSuccess: (_) {
        final updated = state.messages.map((msg) {
          if (msg.localId == localId &&
              msg.deliveryStatus == ChatMessageDeliveryStatus.sending) {
            return msg.copyWith(
              deliveryStatus: ChatMessageDeliveryStatus.sent,
            );
          }
          return msg;
        }).toList();

        emit(
          state.copyWith(
            messages: updated,
            clearError: true,
          ),
        );
      },
      onFailed: (message, code) {
        final updated = state.messages.map((msg) {
          if (msg.localId == localId) {
            return msg.copyWith(
              deliveryStatus: ChatMessageDeliveryStatus.failed,
            );
          }
          return msg;
        }).toList();

        emit(
          state.copyWith(
            messages: updated,
            error: message,
          ),
        );
      },
      onNoInternet: () {
        final updated = state.messages.map((msg) {
          if (msg.localId == localId) {
            return msg.copyWith(
              deliveryStatus: ChatMessageDeliveryStatus.failed,
            );
          }
          return msg;
        }).toList();

        emit(
          state.copyWith(
            messages: updated,
            error: AppStrings.noInternet,
          ),
        );
      },
    );
  }

  Future<void> retryMessage(String localId) async {
    if (!state.canSend) return;

    final msg = state.messages.firstWhere(
      (e) => e.localId == localId,
      orElse: () => ChatUiMessage(
        localId: '',
        senderId: '',
        text: '',
        createdAt: DateTime.now(),
        isMine: true,
        deliveryStatus: ChatMessageDeliveryStatus.failed,
      ),
    );

    if (msg.localId.isEmpty || state.currentConversationId == null) return;

    final updatedStart = state.messages.map((e) {
      if (e.localId == localId) {
        return e.copyWith(deliveryStatus: ChatMessageDeliveryStatus.sending);
      }
      return e;
    }).toList();

    emit(state.copyWith(messages: updatedStart, clearError: true));

    final result = await UserCaseState().chatUserCase.sendMessage(
      conversationId: state.currentConversationId!,
      message: msg.text,
    );

    result.handle(
      onSuccess: (_) {
        final updated = state.messages.map((e) {
          if (e.localId == localId) {
            return e.copyWith(deliveryStatus: ChatMessageDeliveryStatus.sent);
          }
          return e;
        }).toList();

        emit(state.copyWith(messages: updated, clearError: true));
      },
      onFailed: (message, code) {
        final updated = state.messages.map((e) {
          if (e.localId == localId) {
            return e.copyWith(deliveryStatus: ChatMessageDeliveryStatus.failed);
          }
          return e;
        }).toList();

        emit(state.copyWith(messages: updated, error: message));
      },
      onNoInternet: () {
        final updated = state.messages.map((e) {
          if (e.localId == localId) {
            return e.copyWith(deliveryStatus: ChatMessageDeliveryStatus.failed);
          }
          return e;
        }).toList();

        emit(state.copyWith(messages: updated, error: AppStrings.noInternet));
      },
    );
  }

  ChatUiMessage _mapBackendMessageToUi(ChatItemResponse item) {
    final senderId = item.senderId?.toString() ?? '';

    return ChatUiMessage(
      localId: 'server_${item.id ?? DateTime.now().microsecondsSinceEpoch}',
      serverId: item.id,
      senderId: senderId,
      text: item.message ?? '',
      createdAt: item.createdAt ?? DateTime.now(),
      isMine: senderId == _currentUserId,
      deliveryStatus: ChatMessageDeliveryStatus.sent,
    );
  }

  bool isMyMessage(ChatUiMessage item) {
    return item.isMine;
  }

  String formatMessageTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Future<void> close() async {
    await resetActiveChat();
    await _chatHubService.dispose();
    return super.close();
  }
}