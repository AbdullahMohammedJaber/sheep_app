import 'dart:async';

import 'package:sheep/core/server/servise.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/http_connection_options.dart';

class AuctionHubService {
  static const String receiveBidUpdateEvent = 'ReceiveBidUpdate';
  static const String auctionEndedEvent = 'AuctionEnded';
  static const String auctionStoppedEvent = 'AuctionStopped';

  HubConnection? _hubConnection;

  final StreamController<AuctionBidUpdateModel> _bidUpdatesController =
      StreamController<AuctionBidUpdateModel>.broadcast();

  final StreamController<AuctionEndedModel> _auctionEndedController =
      StreamController<AuctionEndedModel>.broadcast();

  final StreamController<AuctionStoppedModel> _auctionStoppedController =
      StreamController<AuctionStoppedModel>.broadcast();

  Stream<AuctionBidUpdateModel> get bidUpdatesStream =>
      _bidUpdatesController.stream;

  Stream<AuctionEndedModel> get auctionEndedStream =>
      _auctionEndedController.stream;

  Stream<AuctionStoppedModel> get auctionStoppedStream =>
      _auctionStoppedController.stream;

  bool get isConnected =>
      _hubConnection?.state?.toString().toLowerCase().contains('connected') ??
      false;

  Future<void> connect({required int auctionId, String? accessToken}) async {
    await disconnect();

    _hubConnection =
        HubConnectionBuilder()
            .withUrl(
              '${ApiService.url}/auctionHub',
              options: HttpConnectionOptions(
                accessTokenFactory:
                    accessToken != null ? () async => accessToken : null,
              ),
            )
            .withAutomaticReconnect()
            .build();

    _hubConnection!.on(receiveBidUpdateEvent, (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final raw = arguments.first;

      if (raw is Map<String, dynamic>) {
        _bidUpdatesController.add(AuctionBidUpdateModel.fromJson(raw));
        return;
      }

      if (raw is Map) {
        _bidUpdatesController.add(
          AuctionBidUpdateModel.fromJson(Map<String, dynamic>.from(raw)),
        );
        return;
      }
    });

    _hubConnection!.on(auctionEndedEvent, (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final raw = arguments.first;

      if (raw is Map<String, dynamic>) {
        _auctionEndedController.add(AuctionEndedModel.fromJson(raw));
        return;
      }

      if (raw is Map) {
        _auctionEndedController.add(
          AuctionEndedModel.fromJson(Map<String, dynamic>.from(raw)),
        );
      }
    });

    _hubConnection!.on(auctionStoppedEvent, (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final raw = arguments.first;

      if (raw is Map<String, dynamic>) {
        _auctionStoppedController.add(AuctionStoppedModel.fromJson(raw));
        return;
      }

      if (raw is Map) {
        _auctionStoppedController.add(
          AuctionStoppedModel.fromJson(Map<String, dynamic>.from(raw)),
        );
      }
    });

    await _hubConnection!.start();

    await _hubConnection!.invoke('JoinAuctionGroup', args: [auctionId]);
  }

  Future<void> leaveAuctionGroup(int auctionId) async {
    try {
      await _hubConnection?.invoke('LeaveAuctionGroup', args: [auctionId]);
    } catch (_) {}
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection?.stop();
    } catch (_) {}
    _hubConnection = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _bidUpdatesController.close();
    await _auctionEndedController.close();
    await _auctionStoppedController.close();
  }
}
