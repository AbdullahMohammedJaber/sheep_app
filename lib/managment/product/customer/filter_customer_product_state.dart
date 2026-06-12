import 'package:sheep/core/data/response/product/product_customer_response.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductFilterCustomerState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ProductCustomer> products;
  final bool hasMore;
  final String? error;

  final String search;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const ProductFilterCustomerState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.products = const [],
    this.hasMore = true,
    this.error,
    this.search = '',
    this.categoryId,
    this.minPrice,
    this.maxPrice,
  });

  ProductFilterCustomerState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ProductCustomer>? products,
    bool? hasMore,
    String? error,
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool clearError = false,
  }) {
    return ProductFilterCustomerState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  ProductFilterCustomerState deleteFilter() {
    return copyWith(categoryId: null, minPrice: null, maxPrice: null);
  }
}
