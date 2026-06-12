import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/util/enum.dart';

class CategoryState {
  // ================= CATEGORIES =================
  final RequestStatus categoryStatus;
  final List<Category> categories;
  final bool categoryHasMore;
  final int categoryPage;

  // ================= BREEDS =================
  final RequestStatus breedStatus;
  final List<Breeds> breeds;
  final bool breedHasMore;
  final int breedPage;

  // ================= ERROR =================
  final String? error;

  const CategoryState({
    required this.categoryStatus,
    required this.categories,
    required this.categoryHasMore,
    required this.categoryPage,
    required this.breedStatus,
    required this.breeds,
    required this.breedHasMore,
    required this.breedPage,
    required this.error,
  });

  // ================= INITIAL =================
  factory CategoryState.initial() {
    return const CategoryState(
      categoryStatus: RequestStatus.initial,
      categories: [],
      categoryHasMore: true,
      categoryPage: 1,

      breedStatus: RequestStatus.initial,
      breeds: [],
      breedHasMore: true,
      breedPage: 1,

      error: null,
    );
  }

  // ================= COPY WITH =================
  CategoryState copyWith({
    RequestStatus? categoryStatus,
    List<Category>? categories,
    bool? categoryHasMore,
    int? categoryPage,

    RequestStatus? breedStatus,
    List<Breeds>? breeds,
    bool? breedHasMore,
    int? breedPage,

    String? error,
    bool clearError = false,
  }) {
    return CategoryState(
      categoryStatus: categoryStatus ?? this.categoryStatus,
      categories: categories ?? this.categories,
      categoryHasMore: categoryHasMore ?? this.categoryHasMore,
      categoryPage: categoryPage ?? this.categoryPage,

      breedStatus: breedStatus ?? this.breedStatus,
      breeds: breeds ?? this.breeds,
      breedHasMore: breedHasMore ?? this.breedHasMore,
      breedPage: breedPage ?? this.breedPage,

      error: clearError ? null : error ?? this.error,
    );
  }
}