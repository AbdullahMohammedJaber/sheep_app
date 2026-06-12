import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheep/core/data/response/category/breeds_response.dart';
import 'package:sheep/core/data/response/category/category_response.dart';
import 'package:sheep/core/data/response/product/details_product_seller.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';
import 'package:sheep/managment/home/seller/home_seller_cubit.dart';
import 'package:sheep/managment/product/seller/product_state.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required ProductFormMode mode,
    ProductFormInitialData? initialData,
  }) : super(ProductFormState.initial(mode: mode, initialData: initialData));

  void updateTitle(String value) {
    emit(state.copyWith(title: value, actionSuccess: false));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value, actionSuccess: false));
  }

  void updateLocation(String value) {
    emit(state.copyWith(location: value, actionSuccess: false));
  }

  void updatePrice(String value) {
    emit(state.copyWith(price: value, actionSuccess: false));
  }

  void updateAge(String value) {
    emit(state.copyWith(age: value, actionSuccess: false));
  }

  void updateWeight(String value) {
    emit(state.copyWith(weight: value, actionSuccess: false));
  }

  void updateCategory(Category value) {
    emit(state.copyWith(selectedCategory: value, actionSuccess: false));
  }

  void updateBreed(Breeds value) {
    emit(state.copyWith(selectedBreed: value, actionSuccess: false));
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isEmpty) return;

    final newImages = pickedFiles.map((e) => File(e.path)).toList();

    final allImages = [...state.images, ...newImages];
    final limitedImages = allImages.take(6).toList();

    emit(
      state.copyWith(
        images: limitedImages,
        selectedImageSource: ProductImageSource.gallery,
      ),
    );
  }

  Future<void> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    final allImages = [...state.images, File(pickedFile.path)];

    if (allImages.length > 6) return;

    emit(
      state.copyWith(
        images: allImages,
        selectedImageSource: ProductImageSource.camera,
      ),
    );
  }

  void removeImage({required int index}) {
    if (index < state.oldImages.length) {
      final updatedOld = List<ImageProduct>.from(state.oldImages)
        ..removeAt(index);

      emit(state.copyWith(oldImages: updatedOld));
    } else {
      final newIndex = index - state.oldImages.length;

      final updatedNew = List<File>.from(state.images)..removeAt(newIndex);

      emit(state.copyWith(images: updatedNew));
    }
  }

  Future<void> submit(BuildContext context) async {
    emit(state.copyWith(isSubmitting: true, actionSuccess: false));

    final result = await UserCaseState().productSellerUserCase.addProduct(
      dataForm: {
        'Name': state.title,
        'Description': state.description,
        'Fixed_Price': state.price,
        'Category_Id': state.selectedCategory.id,
        'Age': state.age,
        'Address': state.location,
        'Breed_Id': state.selectedBreed.id,
        'Wight': state.weight,
      },
      files: state.images,
    );
    result.handle(
      onSuccess: (data) {
        showMessage(
          state.isEditMode ? 'تم حفظ التعديلات بنجاح' : 'تم نشر المنتج بنجاح',
          value: true,
        );
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
        Navigator.pop(context);
        context.read<HomeSellerCubit>().fetchMyProducts(refresh: true);
      },
      onFailed: (message, code) {
        showMessage(message, value: false);
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
    );
  }

  Future<void> update(BuildContext context) async {
    emit(state.copyWith(isSubmitting: true, actionSuccess: false));

    final oldImageIds =
        state.oldImages.where((e) => e.id != null).map((e) => e.id).toList();
 


    final result = await UserCaseState().productSellerUserCase.updateProduct(
      id: int.parse(state.productId.toString()),
      dataForm: {
        'name': state.title,
        'description': state.description,
        'fixed_Price': state.price,
        'category_Id': state.selectedCategory.id,
        'age': state.age,
        'address': state.location,
        'breed_Id': state.selectedBreed.id,
        'wight': state.weight,
        'Old_Images': oldImageIds,
      },
      files: state.images,
    );

    result.handle(
      onSuccess: (data) {
        showMessage('تم حفظ التعديلات بنجاح', value: true);

        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
        toRemoveAll(RootSellerScreen());
      },
      onFailed: (message, code) {
        showMessage(message, value: false);

        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
      onNoInternet: () {
        showMessage(AppStrings.noInternet, value: false);

        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
    );
  }

  void resetActionState() {
    emit(state.copyWith(actionSuccess: false));
  }
}
