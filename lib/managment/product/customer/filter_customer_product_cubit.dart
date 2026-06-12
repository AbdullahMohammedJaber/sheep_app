import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/product/customer/filter_customer_product_state.dart';
 
class ProductFilterCustomerCubit extends Cubit<ProductFilterCustomerState> {
  ProductFilterCustomerCubit() : super(const ProductFilterCustomerState());

  int _page = 1;
  bool _loading = false;
  Timer? _debounce;

  final List<ProductCustomer> _products = [];

  /// ================= FETCH =================
  Future<void> fetchProducts({bool refresh = false}) async {
    if (_loading) return;

    /// ================= REFRESH =================
    if (refresh) {
      _page = 1;
      _products.clear();

      emit(
        state.copyWith(
          isLoading: true,
          isLoadingMore: false,
          hasMore: true,
          error: null,
        ),
      );
    } else {
      if (!state.hasMore) return;

      emit(state.copyWith(isLoadingMore: true));
    }

    _loading = true;

    /// ================= FILTER PARAM =================
    final filter = {
      "PageNumber": _page,

      if (state.search.isNotEmpty) "Search": state.search,
      if (state.categoryId != null) "Category_Id": state.categoryId,
      if (state.minPrice != null) "MinPrice": state.minPrice,
      if (state.maxPrice != null) "MaxPrice": state.maxPrice,
    };

    final result = await UserCaseState()
        .productCustomerUsercase
        .productCustomerRepoImpl
        .getProducts(quary: filter);

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];

        _products.addAll(items);

        final currentPage = data.data?.pageNumber ?? _page;
        final totalPages = data.data?.totalPages ?? _page;

        final hasMore = currentPage < totalPages;

        if (hasMore) _page++;

        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            products: List.from(_products),
            hasMore: hasMore,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: message,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            error: "لا يوجد اتصال بالانترنت",
          ),
        );
      },
    );

    _loading = false;
  }

  /// ================= SEARCH =================
  void onSearch(String value) {
    emit(state.copyWith(search: value));

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchProducts(refresh: true);
    });
  }

  /// ================= APPLY FILTER =================
  void applyFilter({int? categoryId, double? minPrice, double? maxPrice}) {
    emit(
      state.copyWith(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );

    fetchProducts(refresh: true);
  }

  /// ================= CLEAR FILTER =================
  void clearFilter() {
    emit(state.deleteFilter());

    fetchProducts(refresh: true);
  }

  /// ================= RESET ALL =================
  void resetAll() {
    _debounce?.cancel();
    _page = 1;
    _products.clear();

    emit(const ProductFilterCustomerState());

    fetchProducts(refresh: true);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
