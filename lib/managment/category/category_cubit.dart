import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/managment/category/category_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryState.initial());

  // ================= CATEGORIES =================
  int _categoryPage = 1;
  final List<Category> _categories = [];
  bool _categoryHasMore = true;
  bool _categoryLoading = false;

  // ================= BREEDS =================
  int _breedPage = 1;
  final List<Breeds> _breeds = [];
  bool _breedHasMore = true;
  bool _breedLoading = false;

  // ================= CATEGORIES REQUEST =================

  Future<void> fetchCategories({bool refresh = false}) async {
    if (_categoryLoading) return;

    if (refresh) {
      _categoryPage = 1;
      _categoryHasMore = true;
      _categories.clear();

      emit(state.copyWith(
        categoryStatus: RequestStatus.loading,
        clearError: true,
        categoryHasMore: true,
      ));
    }

    if (!_categoryHasMore) return;

    _categoryLoading = true;

    final result = await UserCaseState()
        .categoryUserCase
        .getCategory(page: _categoryPage);

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];

        _categories.addAll(items);

        final currentPage = data.data?.pageNumber ?? _categoryPage;
        final totalPages = data.data?.totalPages ?? _categoryPage;

        _categoryHasMore = currentPage < totalPages;

        if (_categoryHasMore) {
          _categoryPage++;
        }

        emit(state.copyWith(
          categoryStatus: RequestStatus.success,
          categories: List.from(_categories),
          categoryHasMore: _categoryHasMore,
        ));
      },
      onFailed: (message, code) {
        emit(state.copyWith(
          categoryStatus: RequestStatus.failure,
          error: AppStrings.error_try,
        ));
      },
      onNoInternet: () {
        emit(state.copyWith(
          categoryStatus: RequestStatus.failure,
          error: AppStrings.noInternet,
        ));
      },
    );

    _categoryLoading = false;
  }

  // ================= BREEDS REQUEST =================

  Future<void> fetchBreeds({bool refresh = false}) async {
    if (_breedLoading) return;

    if (refresh) {
      _breedPage = 1;
      _breedHasMore = true;
      _breeds.clear();

      emit(state.copyWith(
        breedStatus: RequestStatus.loading,
        clearError: true,
        breedHasMore: true,
      ));
    }

    if (!_breedHasMore) return;

    _breedLoading = true;

    final result = await UserCaseState()
        .categoryUserCase
        .getBreeds(page: _breedPage);

    result.handle(
      onSuccess: (data) {
        final items = data.data?.items ?? [];

        _breeds.addAll(items);

        final currentPage = data.data?.pageNumber ?? _breedPage;
        final totalPages = data.data?.totalPages ?? _breedPage;

        _breedHasMore = currentPage < totalPages;

        if (_breedHasMore) {
          _breedPage++;
        }

        emit(state.copyWith(
          breedStatus: RequestStatus.success,
          breeds: List.from(_breeds),
          breedHasMore: _breedHasMore,
        ));
      },
      onFailed: (message, code) {
        emit(state.copyWith(
          breedStatus: RequestStatus.failure,
          error: AppStrings.error_try,
        ));
      },
      onNoInternet: () {
        emit(state.copyWith(
          breedStatus: RequestStatus.failure,
          error: AppStrings.noInternet,
        ));
      },
    );

    _breedLoading = false;
  }

  // ================= RESET =================

  void reset() {
    _categoryPage = 1;
    _categories.clear();
    _categoryHasMore = true;
    _categoryLoading = false;

    _breedPage = 1;
    _breeds.clear();
    _breedHasMore = true;
    _breedLoading = false;

    emit(CategoryState.initial());
  }
}