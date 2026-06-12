import 'dart:async';
 import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/auction/seller/filter_seller_auction_state.dart';
 class AuctionFilterSellerCubit extends Cubit<AuctionFilterSellerState> {
  AuctionFilterSellerCubit() : super(const AuctionFilterSellerState());

  int _page = 1;
  bool _loading = false;
  Timer? _debounce;

  final List _auctions = [];

  Future<void> fetchAuctions({bool refresh = false}) async {
    if (_loading) return;

    if (refresh) {
      _page = 1;
      _auctions.clear();

      emit(state.copyWith(
        isLoading: true,
        error: null,
        hasMore: true,
      ));
    } else {
      if (!state.hasMore) return;
      emit(state.copyWith(isLoadingMore: true));
    }

    _loading = true;

    final filter = {
      "PageNumber": _page,
      if (state.search.isNotEmpty) "Search": state.search,
      if (state.categoryId != null) "Category_Id": state.categoryId,
      if (state.minBid != null) "MinBid": state.minBid,
      if (state.maxBid != null) "MaxBid": state.maxBid,
      if (state.status.value != null) "Status": state.status.value,
    };

    final result =
        await UserCaseState().auctionSellerUserCase.getMyAuctions(
      filter: filter,
    );

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];
        _auctions.addAll(items);

        final current = data.data?.pageNumber ?? _page;
        final total = data.data?.totalPages ?? _page;

        final hasMore = current < total;
        if (hasMore) _page++;

        emit(state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          auctions: List.from(_auctions),
          hasMore: hasMore,
          error: null,
        ));
      },
      onFailed: (msg, code) {
        emit(state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: msg,
        ));
      },
      onNoInternet: () {
        emit(state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: "لا يوجد اتصال بالانترنت",
        ));
      },
    );

    _loading = false;
  }

  void onSearch(String value) {
    emit(state.copyWith(search: value));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchAuctions(refresh: true);
    });
  }

  void applyFilter({
    int? categoryId,
    double? minBid,
    double? maxBid,
    AuctionStatus? status,
  }) {
    emit(state.copyWith(
      categoryId: Nullable(categoryId),
      minBid: Nullable(minBid),
      maxBid: Nullable(maxBid),
      status: status,
    ));

    fetchAuctions(refresh: true);
  }

  void cleanFilter() {
    emit(state.copyWith(
      categoryId: const Nullable(null),
      minBid: const Nullable(null),
      maxBid: const Nullable(null),
      status: AuctionStatus.all,
      search: '',
    ));

    fetchAuctions(refresh: true);
  }
}