import 'package:equatable/equatable.dart';

enum SellerLiveStatus {
  initial,
  preparing,
  previewReady,
  starting,
  live,
  ending,
  ended,
  error,
}

class SellerLiveState extends Equatable {
  final SellerLiveStatus status;

  final String title;
  final String description;

  final bool isCameraOn;
  final bool isMicOn;
  final bool isPreviewReady;
  final bool isJoined;

  final String? liveId;
  final String? channelName;
  final String? token;
  final int? uid;

  final String? errorMessage;
  final String? successMessage;
  final dynamic id;
  const SellerLiveState({
    this.status = SellerLiveStatus.initial,
    this.title = '',
    this.description = '',
    this.isCameraOn = true,
    this.id,
    this.isMicOn = true,
    this.isPreviewReady = false,
    this.isJoined = false,
    this.liveId,
    this.channelName,
    this.token,
    this.uid,
    this.errorMessage,
    this.successMessage,
  });

  SellerLiveState copyWith({
    SellerLiveStatus? status,
    String? title,
    String? description,
    bool? isCameraOn,
    bool? isMicOn,
    bool? isPreviewReady,
    bool? isJoined,
    String? liveId,
    String? channelName,
    String? token,
    int? uid,
    dynamic id,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SellerLiveState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMicOn: isMicOn ?? this.isMicOn,
      isPreviewReady: isPreviewReady ?? this.isPreviewReady,
      isJoined: isJoined ?? this.isJoined,
      liveId: liveId ?? this.liveId,
      channelName: channelName ?? this.channelName,
      token: token ?? this.token,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  bool get canStart =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      isPreviewReady &&
      status != SellerLiveStatus.starting &&
      status != SellerLiveStatus.ending;

  @override
  List<Object?> get props => [
        status,
        title,
        description,
        isCameraOn,
        isMicOn,
        isPreviewReady,
        isJoined,
        liveId,
        channelName,
        token,
        uid,
        errorMessage,
        successMessage,
        id,
      ];
}