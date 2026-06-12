import 'package:equatable/equatable.dart';

enum CustomerLiveStatus {
  initial,
  loading,
  engineInitializing,
  tokenLoading,
  joining,
  joined,
  liveEnded,
  error,
}

class LiveCustomerState extends Equatable {
  final CustomerLiveStatus status;
  final String? errorMessage;
  final String? successMessage;

  final String? id;
  final String? liveId;
  final String? channelName;
  final String? token;
  final int? uid;

  final int? remoteUid;
  final bool isJoined;
  final bool isLiveEnded;
  final bool isLoadingDetails;

  const LiveCustomerState({
    this.status = CustomerLiveStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.id,
    this.liveId,
    this.channelName,
    this.token,
    this.uid,
    this.remoteUid,
    this.isJoined = false,
    this.isLiveEnded = false,
    this.isLoadingDetails = false,
  });

  LiveCustomerState copyWith({
    CustomerLiveStatus? status,
    String? errorMessage,
    String? successMessage,
    String? id,
    String? liveId,
    String? channelName,
    String? token,
    int? uid,
    int? remoteUid,
    bool? isJoined,
    bool? isLiveEnded,
    bool? isLoadingDetails,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearRemoteUid = false,
  }) {
    return LiveCustomerState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      id: id ?? this.id,
      liveId: liveId ?? this.liveId,
      channelName: channelName ?? this.channelName,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      remoteUid: clearRemoteUid ? null : (remoteUid ?? this.remoteUid),
      isJoined: isJoined ?? this.isJoined,
      isLiveEnded: isLiveEnded ?? this.isLiveEnded,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        successMessage,
        id,
        liveId,
        channelName,
        token,
        uid,
        remoteUid,
        isJoined,
        isLiveEnded,
        isLoadingDetails,
      ];
}