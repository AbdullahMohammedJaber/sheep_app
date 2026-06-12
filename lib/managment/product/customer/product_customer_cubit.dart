import 'package:bloc/bloc.dart';
import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/product/customer/product_customer_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';

class ProductCustomerCubit extends Cubit<ProductCustomerState> {
  ProductCustomerCubit() : super(ProductCustomerState());

  int _page = 1;
  final List<ProductCustomer> _products = [];
  bool _hasMore = true;
  bool _loading = false;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_loading) return;

    if (refresh) {
      _page = 1;
      _products.clear();
      _hasMore = true;

      emit(state.copyWith(
        status: RequestStatus.loading,
        error: null,
        hasMore: true,
      ));
    } else {
      if (!_hasMore) return;

      emit(state.copyWith(isLoadingMore: true));
    }

    _loading = true;

    final result = await UserCaseState()
        .productCustomerUsercase
        .callGetProducts(query: {'page': _page});

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];

        _products.addAll(items);

        final current = data.data?.pageNumber ?? _page;
        final total = data.data?.totalPages ?? _page;

        _hasMore = current < total;

        if (_hasMore) _page++;

        emit(state.copyWith(
          status: RequestStatus.success,
          products: List.from(_products),
          hasMore: _hasMore,
          isLoadingMore: false,
        ));
      },
      onFailed: (message, code) {
        emit(state.copyWith(
          status: RequestStatus.failure,
          error: AppStrings.error_try,
          isLoadingMore: false,
        ));
      },
      onNoInternet: () {
        emit(state.copyWith(
          status: RequestStatus.failure,
          error: AppStrings.noInternet,
          isLoadingMore: false,
        ));
      },
    );

    _loading = false;
  }

  void loadMore() {
    fetchProducts();
  }

  Future<void> refresh() async {
    await fetchProducts(refresh: true);
  }
}