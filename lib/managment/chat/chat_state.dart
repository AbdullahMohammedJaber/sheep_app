import 'package:equatable/equatable.dart';
import 'package:sheep/core/data/response/chat/conversation_response.dart';

enum RequestStatus { initial, loading, success, failure }

enum HubConnectionStatus {
  initial,
  connecting,
  connected,
  failure,
}

enum ChatMessageDeliveryStatus {
  sending,
  sent,
  failed,
}

class ChatUiMessage extends Equatable {
  final String localId;
  final int? serverId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isMine;
  final ChatMessageDeliveryStatus deliveryStatus;

  const ChatUiMessage({
    required this.localId,
    this.serverId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.isMine,
    required this.deliveryStatus,
  });

  ChatUiMessage copyWith({
    String? localId,
    int? serverId,
    String? senderId,
    String? text,
    DateTime? createdAt,
    bool? isMine,
    ChatMessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatUiMessage(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isMine: isMine ?? this.isMine,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  @override
  List<Object?> get props => [
        localId,
        serverId,
        senderId,
        text,
        createdAt,
        isMine,
        deliveryStatus,
      ];
}

class ChatState extends Equatable {
  final RequestStatus conversationsStatus;
  final RequestStatus messagesStatus;
  final RequestStatus startConversationStatus;
  final HubConnectionStatus hubStatus;

  final List<ConversationItemResponse> conversations;
  final List<ChatUiMessage> messages;

  final int? currentConversationId;
  final String currentMessage;

  final bool isHubConnected;
  final String? error;
  final String? hubError;

  const ChatState({
    this.conversationsStatus = RequestStatus.initial,
    this.messagesStatus = RequestStatus.initial,
    this.startConversationStatus = RequestStatus.initial,
    this.hubStatus = HubConnectionStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.currentConversationId,
    this.currentMessage = '',
    this.isHubConnected = false,
    this.error,
    this.hubError,
  });

  bool get canSend =>
      currentConversationId != null &&
      isHubConnected &&
      hubStatus == HubConnectionStatus.connected;

  ChatState copyWith({
    RequestStatus? conversationsStatus,
    RequestStatus? messagesStatus,
    RequestStatus? startConversationStatus,
    HubConnectionStatus? hubStatus,
    List<ConversationItemResponse>? conversations,
    List<ChatUiMessage>? messages,
    int? currentConversationId,
    String? currentMessage,
    bool? isHubConnected,
    String? error,
    String? hubError,
    bool clearError = false,
    bool clearHubError = false,
    bool clearConversationId = false,
    bool clearMessages = false,
  }) {
    return ChatState(
      conversationsStatus: conversationsStatus ?? this.conversationsStatus,
      messagesStatus: messagesStatus ?? this.messagesStatus,
      startConversationStatus:
          startConversationStatus ?? this.startConversationStatus,
      hubStatus: hubStatus ?? this.hubStatus,
      conversations: conversations ?? this.conversations,
      messages: clearMessages ? const [] : (messages ?? this.messages),
      currentConversationId: clearConversationId
          ? null
          : (currentConversationId ?? this.currentConversationId),
      currentMessage: currentMessage ?? this.currentMessage,
      isHubConnected: isHubConnected ?? this.isHubConnected,
      error: clearError ? null : (error ?? this.error),
      hubError: clearHubError ? null : (hubError ?? this.hubError),
    );
  }

  @override
  List<Object?> get props => [
        conversationsStatus,
        messagesStatus,
        startConversationStatus,
        hubStatus,
        conversations,
        messages,
        currentConversationId,
        currentMessage,
        isHubConnected,
        error,
        hubError,
      ];
}