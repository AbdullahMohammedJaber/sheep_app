import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/live/live_commint_model.dart';
import 'package:sheep/core/server/dio_helper.dart';
import 'package:sheep/features/live/live_comments_signalr_service.dart';

import 'live_comments_state.dart';

class LiveCommentsCubit extends Cubit<LiveCommentsState> {
  LiveCommentsCubit(this._service) : super(const LiveCommentsState());

  final LiveCommentsService _service;

  StreamSubscription<LiveCommentModel>? _commentSub;
  StreamSubscription<int>? _viewerCountSub;

  String? _channelName;
  int? _liveStreamId;

  Future<void> connect({
    required String baseUrl,
    required String channelName,
    required int liveStreamId,
    String? accessToken,
  }) async {
    emit(
      state.copyWith(status: LiveCommentsStatus.connecting, clearError: true),
    );

    _channelName = channelName;
    _liveStreamId = liveStreamId;

    try {
      await _service.connect(
        baseUrl: baseUrl,
        channelName: _channelName!,
        accessToken: accessToken,
      );

      await _commentSub?.cancel();
      await _viewerCountSub?.cancel();

      _commentSub = _service.commentsStream.listen((comment) {
        final updatedComments = List<LiveCommentModel>.from(state.comments)
          ..add(comment);

        emit(
          state.copyWith(
            comments: updatedComments,
            status: LiveCommentsStatus.connected,
            clearError: true,
          ),
        );
      });

      _viewerCountSub = _service.viewerCountStream.listen((count) {
        emit(
          state.copyWith(
            viewerCount: count,
            status: LiveCommentsStatus.connected,
            clearError: true,
          ),
        );
      });

      emit(
        state.copyWith(status: LiveCommentsStatus.connected, clearError: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LiveCommentsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void onMessageChanged(String value) {
    emit(state.copyWith(currentMessage: value, clearError: true));
  }

  Future<void> sendComment() async {
    if (_liveStreamId == null) return;
    if (state.currentMessage.trim().isEmpty) return;

    final message = state.currentMessage.trim();

    emit(state.copyWith(status: LiveCommentsStatus.sending, clearError: true));

    try {
      await DioClient().request(
        path: 'LiveStreams/Comment',
        method: 'POST',
        data: {"liveStream_Id": _liveStreamId!, "message": message},
      );
      
      emit(
        state.copyWith(
          currentMessage: '',
          status: LiveCommentsStatus.connected,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LiveCommentsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() async {
    await _commentSub?.cancel();
    await _viewerCountSub?.cancel();
    await _service.dispose();
    return super.close();
  }
}
