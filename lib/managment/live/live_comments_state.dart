import 'package:equatable/equatable.dart';
import 'package:sheep/core/data/response/live/live_commint_model.dart';

 
enum LiveCommentsStatus {
  initial,
  connecting,
  connected,
  sending,
  error,
}

class LiveCommentsState extends Equatable {
  final LiveCommentsStatus status;
  final List<LiveCommentModel> comments;
  final int viewerCount;
  final String currentMessage;
  final String? errorMessage;

  const LiveCommentsState({
    this.status = LiveCommentsStatus.initial,
    this.comments = const [],
    this.viewerCount = 0,
    this.currentMessage = '',
    this.errorMessage,
  });

  LiveCommentsState copyWith({
    LiveCommentsStatus? status,
    List<LiveCommentModel>? comments,
    int? viewerCount,
    String? currentMessage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LiveCommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      viewerCount: viewerCount ?? this.viewerCount,
      currentMessage: currentMessage ?? this.currentMessage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        comments,
        viewerCount,
        currentMessage,
        errorMessage,
      ];
}