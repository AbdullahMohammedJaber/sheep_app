import 'dart:io';
import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';

enum ProductFormMode { create, edit }
enum ProductImageSource { camera, gallery }

class ProductFormInitialData {
  final String? productId;
  final String title;
  final String description;
  final String location;
  final String price;
  final String age;
  final String weight;
  final Category selectedCategory;
  final Breeds selectedBreed;
  final List<ImageProduct> images; 

  const ProductFormInitialData({
    this.productId,
    required this.title,
    required this.images,
    required this.description,
    required this.location,
    required this.price,
    required this.age,
    required this.weight,
    required this.selectedCategory,
    required this.selectedBreed,
  });
}

class ProductFormState {
  final ProductFormMode mode;
  final String? productId;
  final String title;
  final String description;
  final String location;
  final String price;
  final String age;
  final String weight;
  final Category selectedCategory;
  final Breeds selectedBreed;

   final List<ImageProduct> oldImages;  
  final List<File> images;      

  final ProductImageSource? selectedImageSource;
  final bool isSubmitting;
  final bool actionSuccess;
  final List<Category> categories;
  final List<Breeds> breeds;

  const ProductFormState({
    required this.mode,
    required this.productId,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.age,
    required this.weight,
    required this.selectedCategory,
    required this.selectedBreed,
    required this.oldImages,
    required this.images,
    required this.selectedImageSource,
    required this.isSubmitting,
    required this.actionSuccess,
    required this.categories,
    required this.breeds,
  });

   int get totalImagesCount => oldImages.length + images.length;

  bool get isEditMode => mode == ProductFormMode.edit;
 

 

  String get screenTitle =>
      isEditMode ? 'تعديل بيانات المنتج' : 'إضافة منتج جديد';

  String get submitButtonText =>
      isEditMode ? 'حفظ التعديلات' : 'نشر المنتج';

  factory ProductFormState.initial({
    required ProductFormMode mode,
    ProductFormInitialData? initialData,
  }) {
    return ProductFormState(
      mode: mode,
      productId: initialData?.productId,
      title: initialData?.title ?? '',
      description: initialData?.description ?? '',
      location: initialData?.location ?? '',
      price: initialData?.price ?? '',
      age: initialData?.age ?? '',
      weight: initialData?.weight ?? '',
      selectedCategory:
          initialData?.selectedCategory ?? Category(categoryName: ""),
      selectedBreed: initialData?.selectedBreed ?? Breeds(),

       oldImages: initialData?.images ?? [],
      images: [],

      selectedImageSource: null,
      isSubmitting: false,
      actionSuccess: false,
      categories: const [],
      breeds: const [],
    );
  }

  ProductFormState copyWith({
    ProductFormMode? mode,
    String? productId,
    String? title,
    String? description,
    String? location,
    String? price,
    String? age,
    String? weight,
    Category? selectedCategory,
    Breeds? selectedBreed,
    List<ImageProduct>? oldImages,
    List<File>? images,
    ProductImageSource? selectedImageSource,
    bool? isSubmitting,
    bool? actionSuccess,
    List<Category>? categories,
    List<Breeds>? breeds,
  }) {
    return ProductFormState(
      mode: mode ?? this.mode,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      price: price ?? this.price,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBreed: selectedBreed ?? this.selectedBreed,
      oldImages: oldImages ?? this.oldImages,
      images: images ?? this.images,
      selectedImageSource:
          selectedImageSource ?? this.selectedImageSource,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      actionSuccess: actionSuccess ?? this.actionSuccess,
      categories: categories ?? this.categories,
      breeds: breeds ?? this.breeds,
    );
  }
}