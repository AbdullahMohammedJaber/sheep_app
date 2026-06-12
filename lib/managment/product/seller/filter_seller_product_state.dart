import 'package:sheep/core/data/response/product/product_seller_response.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductFilterSellerState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ProductSeller> products;
  final bool hasMore;
  final String? error;

  final String search;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const ProductFilterSellerState({
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

  ProductFilterSellerState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ProductSeller>? products,
    bool? hasMore,
    String? error,
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) {
    return ProductFilterSellerState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
   ProductFilterSellerState deleteFilter(){
     return ProductFilterSellerState(
     
      categoryId: null,
      minPrice: null,
      maxPrice:null,
    );
   }
}
