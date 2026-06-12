import 'dart:async';

import 'package:sheep/core/data/response/chat/chat_response.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/http_connection_options.dart';

 
class ChatHubService {
  static const String defaultReceiveEventName = 'ReceiveMessage';

  HubConnection? _hubConnection;

  final StreamController<ChatItemResponse> _messagesController =
      StreamController<ChatItemResponse>.broadcast();

  Stream<ChatItemResponse> get messagesStream => _messagesController.stream;

  bool get isConnected =>
      _hubConnection?.state?.toString().toLowerCase().contains('connected') ??
      false;

  Future<void> connect({
    required String baseUrl,
    required int conversationId,
    String receiveEventName = defaultReceiveEventName,
    String? accessToken,
  }) async {
    await disconnect();

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/chatHub',
          options: HttpConnectionOptions(
            accessTokenFactory:
                accessToken != null ? () async => accessToken : null,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on(receiveEventName, (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final raw = arguments.first;

      if (raw is Map<String, dynamic>) {
        _messagesController.add(ChatItemResponse.fromJson(raw));
        return;
      }

      if (raw is Map) {
        _messagesController.add(
          ChatItemResponse.fromJson(Map<String, dynamic>.from(raw)),
        );
      }
    });

    await _hubConnection!.start();

    await _hubConnection!.invoke(
      'JoinConversation',
      args: [conversationId.toString()],
    );
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection?.stop();
    } catch (_) {}
    _hubConnection = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
  }
}