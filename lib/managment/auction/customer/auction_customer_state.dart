import 'package:sheep/core/data/response/auction/auction_customer_response.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/core/data/response/live/all_live_response.dart';

enum AuctionStatus {
  all(null),
  active(2),
  ended(3);

  final int? value;
  const AuctionStatus(this.value);

  String get label {
    switch (this) {
      case AuctionStatus.all:
        return "الكل";
      case AuctionStatus.active:
        return "نشط الان";
      case AuctionStatus.ended:
        return "منتهي";
    }
  }
}

enum AuctionHubStatus {
  initial,
  connecting,
  connected,
  failure,
}

enum BuyerAuctionRealtimeStatus {
  initial,
  active,
  ended,
  stopped,
}

class AuctionBidUpdateModel {
  final int auctionId;
  final double currentPrice;
  final String userId;
  final double amount;

  const AuctionBidUpdateModel({
    required this.auctionId,
    required this.currentPrice,
    required this.userId,
    required this.amount,
  });

  factory AuctionBidUpdateModel.fromJson(Map<String, dynamic> json) {
    return AuctionBidUpdateModel(
      auctionId: int.tryParse(
            (json['auctionId'] ?? json['AuctionId'] ?? '').toString(),
          ) ??
          0,
      currentPrice:
          ((json['currentPrice'] ?? json['CurrentPrice']) as num?)
                  ?.toDouble() ??
              0,
      userId: (json['userId'] ?? json['UserId'] ?? '').toString(),
      amount:
          ((json['amount'] ?? json['Amount']) as num?)?.toDouble() ?? 0,
    );
  }
}

class AuctionEndedModel {
  final int auctionId;
  final String winner;
  final double amount;

  const AuctionEndedModel({
    required this.auctionId,
    required this.winner,
    required this.amount,
  });

  factory AuctionEndedModel.fromJson(Map<String, dynamic> json) {
    return AuctionEndedModel(
      auctionId: int.tryParse(
            (json['auctionId'] ?? json['AuctionId'] ?? '').toString(),
          ) ??
          0,
      winner: (json['winner'] ?? json['Winner'] ?? '').toString(),
      amount:
          ((json['amount'] ?? json['Amount']) as num?)?.toDouble() ?? 0,
    );
  }
}

class AuctionStoppedModel {
  final int auctionId;

  const AuctionStoppedModel({
    required this.auctionId,
  });

  factory AuctionStoppedModel.fromJson(Map<String, dynamic> json) {
    return AuctionStoppedModel(
      auctionId: int.tryParse(
            (json['auctionId'] ?? json['AuctionId'] ?? '').toString(),
          ) ??
          0,
    );
  }
}

class AuctionsCustomerState {
  /// Auctions
  final bool isLoading;
  final bool isLoadingMore;
  final List<AuctionCustomer> auctions;
  final bool hasMore;
  final String? error;
  final String search;
  final AuctionStatus selectedStatus;

  /// Live auctions
  final bool isLiveLoading;
  final bool isLiveLoadingMore;
  final List<LiveResponseItem> liveAuctions;
  final bool hasMoreLive;
  final String? liveError;
  final String liveSearch;

  /// Details
  final bool isDetailsLoading;
  final DetailsAuctionsResponse? detailsAuctionResponse;
  final String? detailsError;

  /// Realtime buyer auction
  final AuctionHubStatus auctionHubStatus;
  final BuyerAuctionRealtimeStatus buyerAuctionStatus;
  final int? activeAuctionId;
  final double currentPrice;
  final bool isPlacingBid;
  final String? bidError;
  final String? auctionHubError;
  final AuctionBidUpdateModel? lastBidUpdate;
  final AuctionEndedModel? auctionEnded;
  final AuctionStoppedModel? auctionStopped;

  /// Combined visible bids for UI
  final List<AuctionBid> realtimeBids;

  const AuctionsCustomerState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.auctions = const [],
    this.hasMore = true,
    this.error,
    this.search = '',
    this.selectedStatus = AuctionStatus.all,
    this.isLiveLoading = false,
    this.isLiveLoadingMore = false,
    this.liveAuctions = const [],
    this.hasMoreLive = true,
    this.liveError,
    this.liveSearch = '',
    this.isDetailsLoading = false,
    this.detailsAuctionResponse,
    this.detailsError,
    this.auctionHubStatus = AuctionHubStatus.initial,
    this.buyerAuctionStatus = BuyerAuctionRealtimeStatus.initial,
    this.activeAuctionId,
    this.currentPrice = 0,
    this.isPlacingBid = false,
    this.bidError,
    this.auctionHubError,
    this.lastBidUpdate,
    this.auctionEnded,
    this.auctionStopped,
    this.realtimeBids = const [],
  });

  bool get isAuctionConnected =>
      auctionHubStatus == AuctionHubStatus.connected;

  bool get canPlaceBid =>
      activeAuctionId != null &&
      auctionHubStatus == AuctionHubStatus.connected &&
      buyerAuctionStatus == BuyerAuctionRealtimeStatus.active &&
      !isPlacingBid;

  bool get shouldShowRetryAuctionConnection =>
      activeAuctionId != null &&
      auctionHubStatus == AuctionHubStatus.failure &&
      buyerAuctionStatus == BuyerAuctionRealtimeStatus.active;

  AuctionsCustomerState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<AuctionCustomer>? auctions,
    bool? hasMore,
    String? error,
    String? search,
    AuctionStatus? selectedStatus,
    bool? isLiveLoading,
    bool? isLiveLoadingMore,
    List<LiveResponseItem>? liveAuctions,
    bool? hasMoreLive,
    String? liveError,
    String? liveSearch,
    bool? isDetailsLoading,
    DetailsAuctionsResponse? detailsAuctionResponse,
    String? detailsError,
    AuctionHubStatus? auctionHubStatus,
    BuyerAuctionRealtimeStatus? buyerAuctionStatus,
    int? activeAuctionId,
    double? currentPrice,
    bool? isPlacingBid,
    String? bidError,
    String? auctionHubError,
    AuctionBidUpdateModel? lastBidUpdate,
    AuctionEndedModel? auctionEnded,
    AuctionStoppedModel? auctionStopped,
    List<AuctionBid>? realtimeBids,
    bool clearError = false,
    bool clearLiveError = false,
    bool clearDetailsError = false,
    bool clearBidError = false,
    bool clearAuctionHubError = false,
    bool clearActiveAuctionId = false,
    bool clearAuctionEnded = false,
    bool clearAuctionStopped = false,
    bool clearLastBidUpdate = false,
    bool clearRealtimeBids = false,
  }) {
    return AuctionsCustomerState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      auctions: auctions ?? this.auctions,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      search: search ?? this.search,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLiveLoading: isLiveLoading ?? this.isLiveLoading,
      isLiveLoadingMore: isLiveLoadingMore ?? this.isLiveLoadingMore,
      liveAuctions: liveAuctions ?? this.liveAuctions,
      hasMoreLive: hasMoreLive ?? this.hasMoreLive,
      liveError: clearLiveError ? null : (liveError ?? this.liveError),
      liveSearch: liveSearch ?? this.liveSearch,
      isDetailsLoading: isDetailsLoading ?? this.isDetailsLoading,
      detailsAuctionResponse:
          detailsAuctionResponse ?? this.detailsAuctionResponse,
      detailsError:
          clearDetailsError ? null : (detailsError ?? this.detailsError),
      auctionHubStatus: auctionHubStatus ?? this.auctionHubStatus,
      buyerAuctionStatus: buyerAuctionStatus ?? this.buyerAuctionStatus,
      activeAuctionId: clearActiveAuctionId
          ? null
          : (activeAuctionId ?? this.activeAuctionId),
      currentPrice: currentPrice ?? this.currentPrice,
      isPlacingBid: isPlacingBid ?? this.isPlacingBid,
      bidError: clearBidError ? null : (bidError ?? this.bidError),
      auctionHubError: clearAuctionHubError
          ? null
          : (auctionHubError ?? this.auctionHubError),
      lastBidUpdate: clearLastBidUpdate
          ? null
          : (lastBidUpdate ?? this.lastBidUpdate),
      auctionEnded:
          clearAuctionEnded ? null : (auctionEnded ?? this.auctionEnded),
      auctionStopped:
          clearAuctionStopped ? null : (auctionStopped ?? this.auctionStopped),
      realtimeBids:
          clearRealtimeBids ? const [] : (realtimeBids ?? this.realtimeBids),
    );
  }
}