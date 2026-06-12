import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/core/data/response/product/product_seller_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/home/seller/home_seller_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/message_flash.dart';

class HomeSellerCubit extends Cubit<HomeSellerState> {
  HomeSellerCubit() : super(HomeSellerState.initial());

  // ================= PRODUCTS =================
  int _productPage = 1;
  final List<ProductSeller> _products = [];
  bool _productHasMore = true;
  bool _productLoading = false;

  // ================= PRODUCTS REQUEST =================

  Future<void> fetchMyProducts({bool refresh = false}) async {
    if (_productLoading) return;

    if (refresh) {
      _productPage = 1;
      _productHasMore = true;
      _products.clear();

      emit(
        state.copyWith(
          productStatus: RequestStatus.loading,
          clearError: true,
          productHasMore: true,
        ),
      );
    }

    if (!_productHasMore) return;

    _productLoading = true;

    final result = await UserCaseState().productSellerUserCase.getMyProduct(
      filter: {'PageNumber': _productPage},
    );

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];

        _products.addAll(items);

        final currentPage = data.data?.pageNumber ?? _productPage;
        final totalPages = data.data?.totalPages ?? _productPage;

        _productHasMore = currentPage < totalPages;

        if (_productHasMore) {
          _productPage++;
        }

        emit(
          state.copyWith(
            productStatus: RequestStatus.success,
            products: List.from(_products),
            productHasMore: _productHasMore,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            productStatus: RequestStatus.failure,
            error: AppStrings.error_try,
          ),
        );
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            productStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );
      },
    );

    _productLoading = false;
  }

  Future<void> detailsProduct(dynamic id) async {
    emit(
      state.copyWith(
        detailsProductStatus: RequestStatus.loading,
        clearError: true,
        detailsProduct: null,
      ),
    );
    final result = await UserCaseState().productSellerUserCase.detailsProduct(
      id: id,
    );

    result.handle(
      onSuccess: (data) {
        emit(
          state.copyWith(
            detailsProductStatus: RequestStatus.success,
            detailsProduct: DetailsProductSellerResponse.fromJson(data),
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            detailsProductStatus: RequestStatus.failure,
            error: message,
          ),
        );
        showMessage(message, value: false);
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            detailsProductStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );

        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }

  Future<void> detailsSeller() async {
    emit(
      state.copyWith(
        dataSellerRequestStatus: RequestStatus.loading,
        clearError: true,
        dataSellerResponse: null,
      ),
    );
    final result = await UserCaseState().homeSellerUserCase.getDataSeller();

    result.handle(
      onSuccess: (data) {
        emit(
          state.copyWith(
            dataSellerRequestStatus: RequestStatus.success,
            dataSellerResponse: data,
          ),
        );
      },
      onFailed: (message, code) {
        emit(
          state.copyWith(
            dataSellerRequestStatus: RequestStatus.failure,
            error: message,
          ),
        );
        showMessage(message, value: false);
      },
      onNoInternet: () {
        emit(
          state.copyWith(
            dataSellerRequestStatus: RequestStatus.failure,
            error: AppStrings.noInternet,
          ),
        );

        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }

  Future<void> deleteProduct(BuildContext context, dynamic id) async {
    showBoatToast();
    final result = await UserCaseState().productSellerUserCase.deleteProduct(
      id: id,
    );
    closeAllLoading();
    result.handle(
      onSuccess: (data) {
        showMessage("تم حذف المنتج", value: true);
        Navigator.pop(context);
        Navigator.pop(context);

        fetchMyProducts(refresh: true);
      },
      onFailed: (message, code) {
        showMessage(message, value: false);
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }
  // ================= RESET =================

  void reset() {
    _productPage = 1;
    _products.clear();
    _productHasMore = true;
    _productLoading = false;

    emit(HomeSellerState.initial());
  }
}
