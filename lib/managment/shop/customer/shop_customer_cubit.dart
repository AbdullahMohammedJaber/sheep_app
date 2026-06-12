import 'package:bloc/bloc.dart';
import 'package:sheep/core/data/response/shop/details_shop_response.dart';
import 'package:sheep/core/data/response/shop/shop_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/shop/customer/shop_customer_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';

 
class ShopCustomerCubit extends Cubit<ShopCustomerState> {
  ShopCustomerCubit() : super(ShopCustomerState());

  int _page = 1;
  final List<ShopItemRes> _shops = [];
  bool _hasMore = true;
  bool _loading = false;

  Future<void> fetchShops({bool refresh = false}) async {
    if (_loading) return;

    if (refresh) {
      _page = 1;
      _shops.clear();
      _hasMore = true;

      emit(
        state.copyWith(
          status: RequestStatus.loading,
          error: null,
          hasMore: true,
        ),
      );
    } else {
      if (!_hasMore) return;

      emit(state.copyWith(isLoadingMore: true));
    }

    _loading = true;

    final result = await UserCaseState().shopUseCase.getShops(
      query: {'page': _page},
    );

    result.handle(
      onSuccess: (data) {
        final items = data.items ?? [];

        _shops.addAll(items);

        final current = data.pageNumber ?? _page;
        final total = data.totalPages ?? _page;

        _hasMore = current < total;

        if (_hasMore) _page++;

        emit(
          state.copyWith(
            status: RequestStatus.success,
            shops: List.from(_shops),
            hasMore: _hasMore,
            isLoadingMore: false,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: AppStrings.error_try,
            isLoadingMore: false,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            error: AppStrings.noInternet,
            isLoadingMore: false,
          ),
        );
      },
    );

    _loading = false;
  }

  void loadMore() {
    fetchShops();
  }
Future<void> fetchShopDetails(String userId) async {
  emit(
    state.copyWith(
      detailsStatus: RequestStatus.loading,
      clearDetailsError: true,
    ),
  );

  final result =
      await UserCaseState().shopUseCase.getShopDetails(
        sellerId: userId
      );

  result.handle(
    onSuccess: (data) {
      emit(
        state.copyWith(
          detailsStatus: RequestStatus.success,
          shopDetails: ShopDetailsResponse.fromJson(data),
        ),
      );
    },
    onFailed: (message, code) {
      emit(
        state.copyWith(
          detailsStatus: RequestStatus.failure,
          detailsError: AppStrings.error_try,
        ),
      );
    },
    onNoInternet: () {
      emit(
        state.copyWith(
          detailsStatus: RequestStatus.failure,
          detailsError: AppStrings.noInternet,
        ),
      );
    },
  );
}
  Future<void> refresh() async {
    await fetchShops(refresh: true);
  }
}
