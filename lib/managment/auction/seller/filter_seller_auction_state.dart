import 'package:sheep/core/data/response/auction/auction_seller_response.dart';

class Nullable<T> {
  final T? value;
  const Nullable(this.value);
}

enum AuctionStatus {
  all(null),
  active(2),
  ended(3);

  final int? value;
  const AuctionStatus(this.value);
}

class AuctionFilterSellerState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<AuctionSeller> auctions;
  final bool hasMore;
  final String? error;

  final String search;
  final int? categoryId;
  final double? minBid;
  final double? maxBid;
  final AuctionStatus status;

  const AuctionFilterSellerState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.auctions = const [],
    this.hasMore = true,
    this.error,
    this.search = '',
    this.categoryId,
    this.minBid,
    this.maxBid,
    this.status = AuctionStatus.all,
  });

  AuctionFilterSellerState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<AuctionSeller>? auctions,
    bool? hasMore,
    String? error,
    String? search,
    Nullable<int?>? categoryId,
    Nullable<double?>? minBid,
    Nullable<double?>? maxBid,
    AuctionStatus? status,
  }) {
    return AuctionFilterSellerState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      auctions: auctions ?? this.auctions,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      search: search ?? this.search,
      categoryId: categoryId != null ? categoryId.value : this.categoryId,
      minBid: minBid != null ? minBid.value : this.minBid,
      maxBid: maxBid != null ? maxBid.value : this.maxBid,
      status: status ?? this.status,
    );
  }
}
