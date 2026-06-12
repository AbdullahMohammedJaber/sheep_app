import 'dart:async';

import 'package:sheep/core/data/response/live/live_commint_model.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/http_connection_options.dart';

 
class LiveCommentsService {
  HubConnection? _connection;

  final StreamController<LiveCommentModel> _commentsController =
      StreamController<LiveCommentModel>.broadcast();

  final StreamController<int> _viewerCountController =
      StreamController<int>.broadcast();

  Stream<LiveCommentModel> get commentsStream => _commentsController.stream;
  Stream<int> get viewerCountStream => _viewerCountController.stream;

  Future<void> connect({
    required String baseUrl,
    required String channelName,
    String? accessToken,
  }) async {
    await disconnect();

    _connection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/liveHub',
          options: HttpConnectionOptions(
            accessTokenFactory:
                accessToken != null ? () async => accessToken : null,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _connection!.on('ReceiveComment', (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final raw = arguments.first;
      _commentsController.add(LiveCommentModel.fromSignalR(raw));
    });

    _connection!.on('ViewerCountUpdated', (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final count = int.tryParse(arguments.first.toString()) ?? 0;
      _viewerCountController.add(count);
    });

    await _connection!.start();

    await _connection!.invoke(
      'JoinLive',
      args: [channelName],
    );
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
    } catch (_) {}
    _connection = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _commentsController.close();
    await _viewerCountController.close();
  }
}