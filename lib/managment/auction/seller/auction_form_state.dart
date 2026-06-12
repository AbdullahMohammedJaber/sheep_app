import 'dart:io';

import 'package:flutter/material.dart';

enum AuctionImageSource {
  camera,
  gallery,
}

class AuctionFormState {
  final String title;
  final String address;

  final String description;
  final String startingPrice;
  final String minimumBidIncrement;

  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  final List<File> images;

  final bool isSubmitting;
  final bool actionSuccess;

  const AuctionFormState({
    required this.title,
    required this.address,

    required this.description,
    required this.startingPrice,
    required this.minimumBidIncrement,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.images,
    required this.isSubmitting,
    required this.actionSuccess,
  });

  factory AuctionFormState.initial() {
    return const AuctionFormState(
      title: '',
      description: '',
      address: '',
      startingPrice: '',
      minimumBidIncrement: '',
      startDate: null,
      endDate: null,
      startTime: null,
      endTime: null,
      images: [],
      isSubmitting: false,
      actionSuccess: false,
    );
  }

  AuctionFormState copyWith({
    String? title,
    String? address,

    String? description,
    String? startingPrice,
    String? minimumBidIncrement,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<File>? images,
    bool? isSubmitting,
    bool? actionSuccess,
  }) {
    return AuctionFormState(
      title: title ?? this.title,
      address: address?? this.address,
      description: description ?? this.description,
      startingPrice: startingPrice ?? this.startingPrice,
      minimumBidIncrement:
          minimumBidIncrement ?? this.minimumBidIncrement,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      actionSuccess: actionSuccess ?? this.actionSuccess,
    );
  }
}