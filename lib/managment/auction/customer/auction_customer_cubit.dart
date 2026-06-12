import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/auction/auction_customer_response.dart';
import 'package:sheep/core/data/response/auction/details_auction_response.dart';
import 'package:sheep/core/data/response/live/all_live_response.dart';
import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';
import 'package:sheep/managment/auction/auction_hub_service.dart';
import 'package:sheep/managment/auth/helper.dart';
import 'package:sheep/managment/auction/customer/auction_customer_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';

class AuctionCustomerCubit extends Cubit<AuctionsCustomerState> {
  AuctionCustomerCubit(this._auctionHubService)
    : super(const AuctionsCustomerState());

  final AuctionHubService _auctionHubService;

  int _page = 1;
  bool _loading = false;
  final List<AuctionCustomer> _auctions = [];

  int _livePage = 1;
  bool _liveLoading = false;
  final List<LiveResponseItem> _liveAuctions = [];

  Timer? _debounce;

  StreamSubscription<AuctionBidUpdateModel>? _bidUpdateSubscription;
  StreamSubscription<AuctionEndedModel>? _auctionEndedSubscription;
  StreamSubscription<AuctionStoppedModel>? _auctionStoppedSubscription;

  String? _hubBaseUrl;

  String get _currentUserId =>
      HelperAuth().getUser()?.data?.userId?.toString() ?? '';

  Future<void> fetchAuctions({
    bool refresh = false,
    AuctionStatus? overrideStatus,
  }) async {
    if (_loading) return;

    if (refresh) {
      _page = 1;
      _auctions.clear();
      emit(state.copyWith(isLoading: true, hasMore: true, clearError: true));
    } else {
      if (!state.hasMore) return;
      emit(state.copyWith(isLoadingMore: true, clearError: true));
    }

    _loading = true;

    final statusToSend = overrideStatus ?? state.selectedStatus;

    final query = {
      "PageNumber": _page,
      if (state.search.isNotEmpty) "Search": state.search,
      if (statusToSend.value != null) "Status": statusToSend.value,
    };

    final result = await UserCaseState().auctionCustomerUserCase
        .callGetAuctions(query: query);

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? <AuctionCustomer>[];

        _auctions.addAll(items);

        final current = data.data?.pageNumber ?? _page;
        final total = data.data?.totalPages ?? _page;

        final hasMore = current < total;
        if (hasMore) _page++;

        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            auctions: List<AuctionCustomer>.from(_auctions),
            hasMore: hasMore,
            clearError: true,
          ),
        );
      },
      onFailed: (msg, code) {
        emit(
          state.copyWith(isLoading: false, isLoadingMore: false, error: msg),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: AppStrings.noInternet,
          ),
        );
      },
    );

    _loading = false;
  }

  void loadMore() {
    if (_loading) return;
    fetchAuctions();
  }

  void onSearch(String value) {
    emit(state.copyWith(search: value));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchAuctions(refresh: true);
    });
  }

  void changeStatus(AuctionStatus status) {
    emit(state.copyWith(selectedStatus: status));
    fetchAuctions(refresh: true);
  }

  Future<void> refresh() async {
    await fetchAuctions(refresh: true);
  }

  void fetchLastAuctions() {
    fetchAuctions(refresh: true, overrideStatus: AuctionStatus.active);
  }

  Future<void> fetchLiveAuctions({bool refresh = false}) async {
    print("fetchLiveAuctions called with refresh: $refresh");
    if (_liveLoading) return;

    if (refresh) {
      _livePage = 1;
      _liveAuctions.clear();

      emit(
        state.copyWith(
          isLiveLoading: true,
          hasMoreLive: true,
          clearLiveError: true,
        ),
      );
    } else {
      if (!state.hasMoreLive) return;

      emit(state.copyWith(isLiveLoadingMore: true, clearLiveError: true));
    }

    _liveLoading = true;

    final query = {
      "PageNumber": _livePage,
      "IsActive": true,
      if (state.liveSearch.isNotEmpty) "Search": state.liveSearch,
    };

    final result = await UserCaseState().liveCustomerUserCase.getAllLive(
      query: query,
    );

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? <LiveResponseItem>[];

        _liveAuctions.addAll(items);

        final current = data.data?.pageNumber ?? _livePage;
        final total = data.data?.totalPages ?? _livePage;

        final hasMore = current < total;
        if (hasMore) _livePage++;

        emit(
          state.copyWith(
            isLiveLoading: false,
            isLiveLoadingMore: false,
            liveAuctions: List<LiveResponseItem>.from(_liveAuctions),
            hasMoreLive: hasMore,
            clearLiveError: true,
          ),
        );
      },
      onFailed: (msg, code) {
        emit(
          state.copyWith(
            isLiveLoading: false,
            isLiveLoadingMore: false,
            liveError: msg,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            isLiveLoading: false,
            isLiveLoadingMore: false,
            liveError: AppStrings.noInternet,
          ),
        );
      },
    );

    _liveLoading = false;
  }

  void loadMoreLiveAuctions() {
    if (_liveLoading) return;
    fetchLiveAuctions();
  }

  void onLiveSearch(String value) {
    emit(state.copyWith(liveSearch: value));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchLiveAuctions(refresh: true);
    });
  }

  Future<void> refreshLiveAuctions() async {
    await fetchLiveAuctions(refresh: true);
  }

  Future<void> fetchAuctionDetails(dynamic auctionId) async {
    emit(state.copyWith(isDetailsLoading: true, clearDetailsError: true));

    final result = await UserCaseState().auctionCustomerUserCase
        .getAuctionsDetails(id: auctionId);

    result.handle(
      onSuccess: (data) {
        final currentPrice =
            (data.data?.currentPrice)?.toDouble() ??
            (data.data?.startPrice)?.toDouble() ??
            0;

        final detailsBids = data.data?.bids ?? <AuctionBid>[];

        emit(
          state.copyWith(
            isDetailsLoading: false,
            detailsAuctionResponse: data,
            currentPrice: currentPrice,
            realtimeBids: List<AuctionBid>.from(detailsBids.reversed),
            clearDetailsError: true,
          ),
        );
      },
      onFailed: (msg, code) {
        emit(state.copyWith(isDetailsLoading: false, detailsError: msg));
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            isDetailsLoading: false,
            detailsError: AppStrings.noInternet,
          ),
        );
      },
    );
  }

  Future<void> joinAuction({
    required int auctionId,
    required String hubBaseUrl,
    String? accessToken,
  }) async {
    _hubBaseUrl = hubBaseUrl;

    await leaveCurrentAuction(clearState: false);

    emit(
      state.copyWith(
        activeAuctionId: auctionId,
        auctionHubStatus: AuctionHubStatus.connecting,
        buyerAuctionStatus: BuyerAuctionRealtimeStatus.active,
        isPlacingBid: false,
        clearBidError: true,
        clearAuctionHubError: true,
        clearAuctionEnded: true,
        clearAuctionStopped: true,
        clearLastBidUpdate: true,
      ),
    );

    try {
      await _auctionHubService.connect(
        auctionId: auctionId,
        accessToken: accessToken,
      );

      await _bidUpdateSubscription?.cancel();
      await _auctionEndedSubscription?.cancel();
      await _auctionStoppedSubscription?.cancel();

      _bidUpdateSubscription = _auctionHubService.bidUpdatesStream.listen((
        event,
      ) {
        if (event.auctionId != state.activeAuctionId) return;

        final updatedBids = List<AuctionBid>.from(state.realtimeBids);

        final newBid = AuctionBid(
          amount: event.currentPrice,
          createdAt: DateTime.now(),
          customerId: event.userId,
          customerName: null,
        );

        final bool shouldUpdateFirstItem =
            updatedBids.isNotEmpty &&
            updatedBids.first.customerId == event.userId;

        if (shouldUpdateFirstItem) {
          updatedBids[0] = newBid;
        } else {
          updatedBids.insert(0, newBid);
        }

        emit(
          state.copyWith(
            currentPrice: event.currentPrice,
            lastBidUpdate: event,
            realtimeBids: updatedBids,
            auctionHubStatus: AuctionHubStatus.connected,
            buyerAuctionStatus: BuyerAuctionRealtimeStatus.active,
            clearBidError: true,
            clearAuctionHubError: true,
          ),
        );
      });

      _auctionEndedSubscription = _auctionHubService.auctionEndedStream.listen((
        event,
      ) {
        if (event.auctionId != state.activeAuctionId) return;

        emit(
          state.copyWith(
            auctionEnded: event,
            buyerAuctionStatus: BuyerAuctionRealtimeStatus.ended,
            auctionHubStatus: AuctionHubStatus.connected,
            clearAuctionHubError: true,
          ),
        );
      });

      _auctionStoppedSubscription = _auctionHubService.auctionStoppedStream
          .listen((event) {
            if (event.auctionId != state.activeAuctionId) return;

            emit(
              state.copyWith(
                auctionStopped: event,
                buyerAuctionStatus: BuyerAuctionRealtimeStatus.stopped,
                auctionHubStatus: AuctionHubStatus.connected,
                clearAuctionHubError: true,
              ),
            );
          });

      emit(
        state.copyWith(
          auctionHubStatus: AuctionHubStatus.connected,
          buyerAuctionStatus: BuyerAuctionRealtimeStatus.active,
          clearAuctionHubError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          auctionHubStatus: AuctionHubStatus.failure,
          auctionHubError: e.toString(),
        ),
      );
    }
  }

  Future<void> retryJoinAuction() async {
    final auctionId = state.activeAuctionId;
    if (auctionId == null || _hubBaseUrl == null || _hubBaseUrl!.isEmpty) {
      return;
    }

    await joinAuction(auctionId: auctionId, hubBaseUrl: _hubBaseUrl!);
  }

  Future<void> placeBid({
    required int auctionId,
    required double amount,
  }) async {
    if (!state.canPlaceBid) return;

    emit(state.copyWith(isPlacingBid: true, clearBidError: true));

    final result = await UserCaseState().auctionCustomerUserCase.placeBid(
      amount: amount,
      id: auctionId,
    );

    result.handle(
      onSuccess: (_) {
        final updatedBids = List<AuctionBid>.from(state.realtimeBids);

        final newBid = AuctionBid(
          amount: amount,
          createdAt: DateTime.now(),
          customerId: _currentUserId,
          customerName: "أنت", // اختياري
        );

        final bool shouldUpdateFirstItem =
            updatedBids.isNotEmpty &&
            updatedBids.first.customerId == _currentUserId;

        if (shouldUpdateFirstItem) {
          updatedBids[0] = newBid;
        } else {
          updatedBids.insert(0, newBid);
        }

        emit(
          state.copyWith(
            isPlacingBid: false,
            currentPrice: amount,
            realtimeBids: updatedBids,
            clearBidError: true,
          ),
        );
      },
      onFailed: (msg, code) {
        emit(state.copyWith(isPlacingBid: false, bidError: msg));
      },
      onNoInternet: () {
        emit(
          state.copyWith(isPlacingBid: false, bidError: AppStrings.noInternet),
        );
      },
    );
  }

  bool isMyLastBid() {
    final lastBid = state.lastBidUpdate;
    if (lastBid == null) return false;
    return lastBid.userId == _currentUserId;
  }

  Future<void> leaveCurrentAuction({bool clearState = true}) async {
    final auctionId = state.activeAuctionId;

    await _bidUpdateSubscription?.cancel();
    await _auctionEndedSubscription?.cancel();
    await _auctionStoppedSubscription?.cancel();

    _bidUpdateSubscription = null;
    _auctionEndedSubscription = null;
    _auctionStoppedSubscription = null;

    if (auctionId != null) {
      await _auctionHubService.leaveAuctionGroup(auctionId);
    }

    await _auctionHubService.disconnect();

    if (clearState) {
      emit(
        state.copyWith(
          auctionHubStatus: AuctionHubStatus.initial,
          buyerAuctionStatus: BuyerAuctionRealtimeStatus.initial,
          clearActiveAuctionId: true,
          currentPrice: 0,
          isPlacingBid: false,
          clearBidError: true,
          clearAuctionHubError: true,
          clearAuctionEnded: true,
          clearAuctionStopped: true,
          clearLastBidUpdate: true,
          clearRealtimeBids: true,
        ),
      );
    }
  }

  void clearBidError() {
    emit(state.copyWith(clearBidError: true));
  }

  void clearAuctionHubError() {
    emit(state.copyWith(clearAuctionHubError: true));
  }

  Future<void> acceptAuction({required dynamic auctionId}) async {
    showBoatToast();
    final result = await DioClient().request(
      path: 'Auctions/AcceptAuction',
      method: 'POST',
      queryParameters: {"id": auctionId},
    );
    closeAllLoading();

    result.handle(
      onSuccess: (data) {
        showMessage(data['message'], value: true);
        toRemoveAll(RootSellerScreen());

      },
      onFailed: (message, code) {
        showMessage(message, value: false);
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);

      },
    );
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await leaveCurrentAuction();
    await _auctionHubService.dispose();
    return super.close();
  }
}
