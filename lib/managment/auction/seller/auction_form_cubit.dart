import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';

import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';
import 'auction_form_state.dart';
import 'package:flutter/material.dart';

class AuctionFormCubit extends Cubit<AuctionFormState> {
  AuctionFormCubit() : super(AuctionFormState.initial());

  static const int maxImages = 6;

  void updateTitle(String v) => emit(state.copyWith(title: v));
  void updateAddress(String v) => emit(state.copyWith(address: v));


  void updateDescription(String v) => emit(state.copyWith(description: v));

  void updateStartingPrice(String v) => emit(state.copyWith(startingPrice: v));

  void updateMinimumBidIncrement(String v) =>
      emit(state.copyWith(minimumBidIncrement: v));

  final ImagePicker _picker = ImagePicker();

  Future<void> selectGallery() async {
    if (state.images.length >= maxImages) return;

    final List<XFile> files = await _picker.pickMultiImage();

    if (files.isEmpty) return;

    final current = List<File>.from(state.images);

    for (final file in files) {
      if (current.length >= maxImages) break;
      current.add(File(file.path));
    }

    emit(state.copyWith(images: current));
  }

  Future<void> selectCamera() async {
    if (state.images.length >= maxImages) return;

    final XFile? file = await _picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      final updated = List<File>.from(state.images)..add(File(file.path));

      emit(state.copyWith(images: updated));
    }
  }

  void removeImage(int index) {
    final updated = List<File>.from(state.images)..removeAt(index);

    emit(state.copyWith(images: updated));
  }

  void setStartDate(DateTime date) => emit(state.copyWith(startDate: date));

  void setEndDate(DateTime date) => emit(state.copyWith(endDate: date));

  void setStartTime(TimeOfDay time) => emit(state.copyWith(startTime: time));

  void setEndTime(TimeOfDay time) => emit(state.copyWith(endTime: time));

  DateTime _merge(DateTime d, TimeOfDay t) {
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  bool validateDateTime() {
    if (state.startDate == null ||
        state.endDate == null ||
        state.startTime == null ||
        state.endTime == null) {
      return false;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final startDateOnly = DateTime(
      state.startDate!.year,
      state.startDate!.month,
      state.startDate!.day,
    );

    final endDateOnly = DateTime(
      state.endDate!.year,
      state.endDate!.month,
      state.endDate!.day,
    );

    if (startDateOnly.isBefore(today)) return false;

    if (endDateOnly.isBefore(startDateOnly)) return false;

    final start = DateTime(
      state.startDate!.year,
      state.startDate!.month,
      state.startDate!.day,
      state.startTime!.hour,
      state.startTime!.minute,
    );

    final end = DateTime(
      state.endDate!.year,
      state.endDate!.month,
      state.endDate!.day,
      state.endTime!.hour,
      state.endTime!.minute,
    );

    if (!end.isAfter(start)) return false;

    return true;
  }

  Future<void> submit() async {
    if (!validateDateTime()) return;

    final start = _merge(state.startDate!, state.startTime!);
    final end = _merge(state.endDate!, state.endTime!);

    final body = {
      "Start_Time": start.toUtc().toIso8601String(),
      "End_Time": end.toUtc().toIso8601String(),
      "Title": state.title,
      "Description": state.description,
      "Address": state.address,
      "Start_Price": state.startingPrice,
    };
    print(body);
    emit(state.copyWith(isSubmitting: true));
    final result = await UserCaseState().auctionSellerUserCase.addAuction(
      dataAuction: body,
      images: state.images,
    );
    result.handle(
      onSuccess: (data) {
        showMessage("تم إضافة المزاد بنجاح", value: true);
        toRemoveAll(RootSellerScreen());
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
      onFailed: (message, code) {
        showMessage(message, value: false);
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
      },
      onNoInternet: () {
        emit(state.copyWith(isSubmitting: false, actionSuccess: true));
        showMessage(AppStrings.noInternet, value: false);
      },
    );
  }

  void resetActionState() {
    emit(state.copyWith(actionSuccess: false));
  }
}
