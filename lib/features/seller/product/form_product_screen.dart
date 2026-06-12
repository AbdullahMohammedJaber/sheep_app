import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/seller/product/widget/category_dialog.dart';
import 'package:sheep/managment/category/category_cubit.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/features/seller/product/widget/app_text_field.dart';
import 'package:sheep/features/seller/product/widget/dialog_option_tile.dart';
import 'package:sheep/features/seller/product/widget/product_action_section.dart';
import 'package:sheep/features/seller/product/widget/product_breed_section.dart';
import 'package:sheep/features/seller/product/widget/product_category_section.dart';
import 'package:sheep/features/seller/product/widget/product_image_section.dart';
import 'package:sheep/features/seller/product/widget/product_text_faild_section.dart';
import 'package:sheep/features/seller/product/widget/selection_bottom_sheet.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/product/seller/product_cubit.dart';
import 'package:sheep/managment/product/seller/product_state.dart';
import 'package:sheep/util/widgets/custom_validation.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProductFormCubit>().state;
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _locationController = TextEditingController(text: state.location);
    _priceController = TextEditingController(text: state.price);
    _ageController = TextEditingController(text: state.age);
    _weightController = TextEditingController(text: state.weight);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? _numberValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }

    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName يجب أن يكون رقمًا';
    }

    if (number < 0) {
      return '$fieldName يجب أن يكون أكبر من أو يساوي 0';
    }

    return null;
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final cubit = context.read<ProductFormCubit>();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: SelectionBottomSheet(
            title: 'اختيار الصورة',
            subtitle: 'اختر مصدر الصورة التي تريد إضافتها',
            children: [
              DialogOptionTile(
                icon: Icons.photo_library_outlined,
                title: 'المعرض',
                subtitle: 'اختيار صور من ألبوم الصور',
                onTap: () async {
                  Navigator.pop(context);

                  await cubit.pickFromGallery();
                },
              ),

              const SizedBox(height: 12),

              DialogOptionTile(
                icon: Icons.photo_camera_outlined,
                title: 'الكاميرا',
                subtitle: 'التقاط صورة جديدة بالكاميرا',
                onTap: () async {
                  Navigator.pop(context);

                  await cubit.pickFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<ProductFormCubit>();

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                arrowLift(
                  context,
                  state.mode == ProductFormMode.edit
                      ? "تعديل المنتج"
                      : "إضافة منتج",
                ),
                SizedBox(height: hi * 0.01),
                Divider(thickness: 1, color: AppColors.border),
                const SizedBox(height: 24),
                ProductImagesSection(
                  images: state.images,
                  oldImages: state.oldImages,
                  onDelete: (index) => cubit.removeImage(index: index),
                  onTap: () => _showImageSourceDialog(context),
                ),
                const SizedBox(height: 24),
                ProductTextFieldSection(
                  title: 'اسم المنتج',
                  child: AppTextField(
                    controller: _titleController,
                    hint: 'ادخل اسم المنتج',
                    validator:
                        (value) => _requiredValidator(value, 'اسم المنتج'),
                    onChanged: cubit.updateTitle,
                  ),
                ),
                const SizedBox(height: 22),
                ProductTextFieldSection(
                  title: 'الوصف',
                  child: AppTextField(
                    controller: _descriptionController,
                    hint: 'اكتب وصف تفصيلي للمنتج',
                    maxLines: 5,
                    validator:
                        (value) => _requiredValidator(value, 'وصف المنتج'),
                    onChanged: cubit.updateDescription,
                  ),
                ),
                const SizedBox(height: 22),
                ValidateWidget(
                  validator: (value) {
                    if (state.selectedCategory.categoryName!.isEmpty) {
                      return "الرجاء اختيار التصنيف";
                    }
                    return null;
                  },
                  child: ProductCategorySection(
                    selectedCategory: state.selectedCategory.categoryName ?? "",
                    onTap:
                        () => showDialog(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<CategoryCubit>(),
                              child: CategoryDialog(
                                onSelected: (category) {
                                  context
                                      .read<ProductFormCubit>()
                                      .updateCategory(category);
                                },
                              ),
                            );
                          },
                        ),
                  ),
                ),
                const SizedBox(height: 22),
                ProductBreedSection(
                  selectedBreed: state.selectedBreed.breedName ?? "",
                  onBreedSelected: (value) {
                    context.read<ProductFormCubit>().updateBreed(value);
                  },
                ),
                const SizedBox(height: 22),
                ProductTextFieldSection(
                  title: 'الموقع',
                  child: AppTextField(
                    controller: _locationController,
                    hint: 'ادخل العنوان بالتفصيل ( المدينة، المنطقة )',
                    validator: (value) => _requiredValidator(value, 'الموقع'),
                    onChanged: cubit.updateLocation,
                  ),
                ),
                const SizedBox(height: 22),
                ProductTextFieldSection(
                  title: 'السعر',
                  child: AppTextField(
                    controller: _priceController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) => _numberValidator(value, 'السعر'),
                    onChanged: cubit.updatePrice,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ProductTextFieldSection(
                        title: 'العمر',
                        child: AppTextField(
                          controller: _ageController,
                          hint: 'ادخل العمر',
                          validator:
                              (value) => _requiredValidator(value, 'العمر'),
                          onChanged: cubit.updateAge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ProductTextFieldSection(
                        title: 'الوزن التقريبي (كجم)',
                        child: AppTextField(
                          controller: _weightController,
                          hint: '0',
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  _numberValidator(value, 'الوزن التقريبي'),
                          onChanged: cubit.updateWeight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ProductActionsSection(
                  submitText: state.submitButtonText,
                  isLoading: state.isSubmitting,
                  submitButtonColor:
                      state.isEditMode ? AppColors.success : AppColors.primary,
                  onSubmit: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (state.isEditMode) {
                         cubit.update(context);
                      } else {
                        cubit.submit(context);
                      }
                    }
                  },
                  onCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
