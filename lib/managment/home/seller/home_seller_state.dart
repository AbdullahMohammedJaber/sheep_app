import 'package:sheep/core/data/response/home/data_seller_response.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/core/data/response/product/product_seller_response.dart';
import 'package:sheep/util/enum.dart';

class HomeSellerState {
  // ================= PRODUCTS =================
  final RequestStatus productStatus;
  final List<ProductSeller> products;
  final bool productHasMore;
  final int productPage;
  // ================= DETAILS PRODUCTS =================
  final DetailsProductSellerResponse? detailsProduct;
  final RequestStatus detailsProductStatus;
  // ================= DETAILS Seller =================
  final DataSellerResponse? dataSellerResponse;
  final RequestStatus dataSellerRequestStatus;
  // ================= ERROR =================
  final String? error;

  const HomeSellerState({
    required this.productStatus,
    required this.products,
    required this.productHasMore,
    required this.productPage,
    required this.error,
    this.detailsProduct,
    this.dataSellerResponse,
    this.dataSellerRequestStatus = RequestStatus.loading,
    this.detailsProductStatus = RequestStatus.loading,
  });

  // ================= INITIAL =================
  factory HomeSellerState.initial() {
    return const HomeSellerState(
      productStatus: RequestStatus.loading,
      products: [],
      productHasMore: true,
      productPage: 1,
      error: null,
    );
  }

  // ================= COPY WITH =================
  HomeSellerState copyWith({
    RequestStatus? productStatus,
    List<ProductSeller>? products,
    bool? productHasMore,
    int? productPage,
    String? error,
    bool clearError = false,
    DetailsProductSellerResponse? detailsProduct,
    RequestStatus? detailsProductStatus,
    DataSellerResponse? dataSellerResponse,
    RequestStatus? dataSellerRequestStatus,
  }) {
    return HomeSellerState(
      productStatus: productStatus ?? this.productStatus,
      products: products ?? this.products,
      productHasMore: productHasMore ?? this.productHasMore,
      productPage: productPage ?? this.productPage,
      error: clearError ? null : error ?? this.error,
      detailsProduct: detailsProduct ?? this.detailsProduct,
      detailsProductStatus: detailsProductStatus ?? this.detailsProductStatus,
      dataSellerRequestStatus:
          dataSellerRequestStatus ?? this.dataSellerRequestStatus,
      dataSellerResponse: dataSellerResponse ?? this.dataSellerResponse,
    );
  }
}
