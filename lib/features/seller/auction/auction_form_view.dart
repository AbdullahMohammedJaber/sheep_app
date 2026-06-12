import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/features/seller/auction/widget/auction_actions_section.dart';
import 'package:sheep/features/seller/auction/widget/auction_images_section.dart';
import 'package:sheep/features/seller/auction/widget/auction_text_field_section.dart';
import 'package:sheep/features/seller/product/widget/app_text_field.dart';
import 'package:sheep/features/seller/product/widget/dialog_option_tile.dart';
import 'package:sheep/features/seller/product/widget/selection_bottom_sheet.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/auction/seller/auction_form_cubit.dart';
import 'package:sheep/managment/auction/seller/auction_form_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/message_flash.dart';

class AuctionFormView extends StatefulWidget {
  const AuctionFormView({super.key});

  @override
  State<AuctionFormView> createState() => _AuctionFormViewState();
}

class _AuctionFormViewState extends State<AuctionFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _addressController;

  late final TextEditingController _descriptionController;
  late final TextEditingController _startingPriceController;
  late final TextEditingController _minimumBidIncrementController;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuctionFormCubit>().state;
    _addressController = TextEditingController(text: state.address);
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _startingPriceController = TextEditingController(text: state.startingPrice);
    _minimumBidIncrementController = TextEditingController(
      text: state.minimumBidIncrement,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startingPriceController.dispose();
    _minimumBidIncrementController.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'مطلوب' : null;

  String? _number(String? v) {
    if (v == null || v.trim().isEmpty) return 'مطلوب';
    final n = double.tryParse(v);
    return n == null || n < 0 ? 'رقم غير صالح' : null;
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final cubit = context.read<AuctionFormCubit>();

    if (cubit.state.images.length >= 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("الحد الأقصى 6 صور")));
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: SelectionBottomSheet(
            title: 'اختيار الصورة',
            subtitle: 'اختر مصدر الصورة',
            children: [
              DialogOptionTile(
                icon: Icons.photo_library_outlined,
                title: 'المعرض',
                subtitle: 'اختيار صورة',
                onTap: () {
                  Navigator.pop(context);
                  cubit.selectGallery();
                },
              ),
              const SizedBox(height: 12),
              DialogOptionTile(
                icon: Icons.photo_camera_outlined,
                title: 'الكاميرا',
                subtitle: 'التقاط صورة',
                onTap: () {
                  Navigator.pop(context);
                  cubit.selectCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AuctionFormCubit, AuctionFormState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<AuctionFormCubit>();

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  arrowLift(context, "إضافة مزاد جديد"),
                  SizedBox(height: hi * 0.01),
                  Divider(color: AppColors.border),

                  AuctionImagesSection(
                    images: state.images,
                    onTap: () => _showImageSourceDialog(context),
                    onDelete: (index) => cubit.removeImage(index),
                  ),
                  const SizedBox(height: 24),

                  AuctionTextFieldSection(
                    title: 'اسم المزاد',
                    child: AppTextField(
                      controller: _titleController,
                      hint: 'ادخل اسم المزاد',
                      validator: _required,
                      onChanged: cubit.updateTitle,
                    ),
                  ),

                  const SizedBox(height: 22),
                  AuctionTextFieldSection(
                    title: 'العنوان',
                    child: AppTextField(
                      controller: _addressController,
                      hint: 'ادخل عنوان المزاد',
                      validator: _required,
                      onChanged: cubit.updateAddress,
                    ),
                  ),

                  const SizedBox(height: 22),
                  AuctionTextFieldSection(
                    title: 'الوصف',
                    child: AppTextField(
                      controller: _descriptionController,
                      hint: 'اكتب وصف',
                      maxLines: 5,
                      validator: _required,
                      onChanged: cubit.updateDescription,
                    ),
                  ),

                  const SizedBox(height: 22),

                  AuctionTextFieldSection(
                    title: 'السعر الابتدائي',
                    child: AppTextField(
                      controller: _startingPriceController,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: _number,
                      onChanged: cubit.updateStartingPrice,
                    ),
                  ),

                  const SizedBox(height: 22),

                  AuctionTextFieldSection(
                    title: 'الحد الأدنى للمزايدة',
                    child: AppTextField(
                      controller: _minimumBidIncrementController,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: _number,
                      onChanged: cubit.updateMinimumBidIncrement,
                    ),
                  ),

                  const SizedBox(height: 22),

                  AuctionTextFieldSection(
                    title: 'مدة المزاد',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _startDateController,
                                hint: 'تاريخ البداية',
                                readOnly: true,
                                validator: _required,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (picked != null) {
                                    _startDateController.text =
                                        "${picked.year}-${picked.month}-${picked.day}";
                                    cubit.setStartDate(picked);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppTextField(
                                controller: _endDateController,
                                hint: 'تاريخ النهاية',
                                readOnly: true,
                                validator: _required,
                                onTap: () async {
                                  final start = state.startDate;

                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: start ?? DateTime.now(),
                                    firstDate: start ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (picked != null) {
                                    _endDateController.text =
                                        "${picked.year}-${picked.month}-${picked.day}";
                                    cubit.setEndDate(picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _startTimeController,
                                hint: 'وقت البداية',
                                readOnly: true,
                                validator: _required,
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (picked != null) {
                                    _startTimeController.text = picked.format(
                                      context,
                                    );
                                    cubit.setStartTime(picked);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppTextField(
                                controller: _endTimeController,
                                hint: 'وقت النهاية',
                                readOnly: true,
                                validator: _required,
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (picked != null) {
                                    final s = state;

                                    if (s.startDate != null &&
                                        s.endDate != null &&
                                        s.startTime != null &&
                                        _isSameDay(s.startDate!, s.endDate!)) {
                                      final startMin =
                                          s.startTime!.hour * 60 +
                                          s.startTime!.minute;

                                      final endMin =
                                          picked.hour * 60 + picked.minute;

                                      if (endMin <= startMin) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "وقت النهاية يجب أن يكون بعد البداية",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                    }

                                    _endTimeController.text = picked.format(
                                      context,
                                    );
                                    cubit.setEndTime(picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  AuctionActionsSection(
                    isLoading: state.isSubmitting,
                    onSubmit: () {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        if (!cubit.validateDateTime()) {
                          showMessage(
                            "الرجاء التحقق من توقيت المزاد",
                            value: false,
                          );
                          return;
                        }

                        cubit.submit();
                      }
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
