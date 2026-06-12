import 'package:sheep/core/data/response/product/product_customer_response.dart';
import 'package:sheep/util/enum.dart';

class ProductCustomerState {
  final RequestStatus status;
  final List<ProductCustomer> products;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

  const ProductCustomerState({
    this.status = RequestStatus.initial,
    this.products = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.error,
  });

  ProductCustomerState copyWith({
    RequestStatus? status,
    List<ProductCustomer>? products,
    bool? hasMore,
    bool? isLoadingMore,
    String? error,
  }) {
    return ProductCustomerState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}