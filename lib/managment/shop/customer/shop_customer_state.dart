import 'package:sheep/core/data/response/shop/details_shop_response.dart';
import 'package:sheep/core/data/response/shop/shop_response.dart';
import 'package:sheep/util/enum.dart';

class ShopCustomerState {
  final RequestStatus status;
  final List<ShopItemRes> shops;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

 
  final RequestStatus detailsStatus;
  final ShopDetailsResponse? shopDetails;
  final String? detailsError;

  const ShopCustomerState({
    this.status = RequestStatus.initial,
    this.shops = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.error,

     this.detailsStatus = RequestStatus.initial,
    this.shopDetails,
    this.detailsError,
  });

  ShopCustomerState copyWith({
    RequestStatus? status,
    List<ShopItemRes>? shops,
    bool? hasMore,
    bool? isLoadingMore,
    String? error,

     RequestStatus? detailsStatus,
    ShopDetailsResponse? shopDetails,
    String? detailsError,
    bool clearDetailsError = false,
  }) {
    return ShopCustomerState(
      status: status ?? this.status,
      shops: shops ?? this.shops,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,

       detailsStatus: detailsStatus ?? this.detailsStatus,
      shopDetails: shopDetails ?? this.shopDetails,
      detailsError:
          clearDetailsError ? null : (detailsError ?? this.detailsError),
    );
  }
}