import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/util/NavigatorObserver/Navigator_observe.dart';

import 'live_customer_state.dart';

class LiveCustomerCubit extends Cubit<LiveCustomerState> {
  LiveCustomerCubit() : super(const LiveCustomerState());

  RtcEngine? _engine;

 
  static const String appId = 'd20905f569bc4127addb1684ddfdc0c0';

  Future<void> initAndJoinAsAudience({
    required String id,
    required String channelName,
  }) async {
    try {
      emit(
        state.copyWith(
          status: CustomerLiveStatus.loading,
          id: id,
          channelName: channelName,
          clearError: true,
          clearSuccess: true,
        ),
      );

      await _initEngine();

      emit(
        state.copyWith(
          status: CustomerLiveStatus.tokenLoading,
          clearError: true,
          clearSuccess: true,
        ),
      );

      final tokenResult = await UserCaseState().liveSellerUserCase.getToken(
        channleName: channelName,
      );

      tokenResult.handle(
        onSuccess: (tokenData) async {
          try {
            final String token = (tokenData['token']['token']).toString();
            final String liveId = (tokenData['token']['live_Id']).toString();
            final String userId = (tokenData['token']['uid']).toString();

            if (token.isEmpty) {
              emit(
                state.copyWith(
                  status: CustomerLiveStatus.error,
                  errorMessage: 'لم يتم استلام التوكن من السيرفر',
                  clearSuccess: true,
                ),
              );
              return;
            }

            emit(
              state.copyWith(
                status: CustomerLiveStatus.joining,
                channelName: channelName,
                token: token,
                liveId: liveId,
                uid: int.tryParse(userId),
                id: id,
                clearError: true,
                clearSuccess: true,
              ),
            );

            await _engine!.joinChannel(
              token: token,
              channelId: channelName,
              uid: int.tryParse(userId) ?? 0,
              options: const ChannelMediaOptions(
                clientRoleType: ClientRoleType.clientRoleAudience,
                publishCameraTrack: false,
                publishMicrophoneTrack: false,
                autoSubscribeAudio: true,
                autoSubscribeVideo: true,
              ),
            );
          } catch (e, s) {
            log('join audience error: $e');
            log('$s');
            emit(
              state.copyWith(
                status: CustomerLiveStatus.error,
                errorMessage: 'حدث خطأ أثناء الانضمام للبث',
                clearSuccess: true,
              ),
            );
          }
        },
        onFailed: (message, code) {
          emit(
            state.copyWith(
              status: CustomerLiveStatus.error,
              errorMessage: message,
              clearSuccess: true,
            ),
          );
        },
      );
    } catch (e, s) {
      log('initAndJoinAsAudience error: $e');
      log('$s');
      emit(
        state.copyWith(
          status: CustomerLiveStatus.error,
          errorMessage: 'حدث خطأ أثناء تهيئة بث المشاهدة',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> _initEngine() async {
    if (_engine != null) return;

    emit(
      state.copyWith(
        status: CustomerLiveStatus.engineInitializing,
        clearError: true,
      ),
    );

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine!.enableVideo();
    await _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          emit(
            state.copyWith(
              status: CustomerLiveStatus.joined,
              isJoined: true,
              clearError: true,
            ),
          );
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          emit(
            state.copyWith(
              remoteUid: remoteUid,
              status: CustomerLiveStatus.joined,
              isJoined: true,
              isLiveEnded: false,
              clearError: true,
            ),
          );
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          emit(
            state.copyWith(
              status: CustomerLiveStatus.liveEnded,
              isLiveEnded: true,
              isJoined: false,
              clearRemoteUid: true,
            ),
          );
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          emit(state.copyWith(isJoined: false, clearRemoteUid: true));
        },
        onError: (ErrorCodeType err, String msg) {
          emit(
            state.copyWith(
              status: CustomerLiveStatus.error,
              errorMessage: msg.isNotEmpty ? msg : 'حدث خطأ في Agora: $err',
              clearSuccess: true,
            ),
          );
        },
        onConnectionStateChanged: (
          RtcConnection connection,
          ConnectionStateType stateType,
          ConnectionChangedReasonType reason,
        ) {
          if (stateType == ConnectionStateType.connectionStateDisconnected) {
            emit(state.copyWith(isJoined: false));
          }
        },
        onTokenPrivilegeWillExpire: (
          RtcConnection connection,
          String token,
        ) async {
           Navigator.pop(NavigationService.navigatorKey.currentContext! );
          await renewToken();
        },
      ),
    );
  }

  Future<void> renewToken() async {
    try {
      if (state.channelName == null || state.channelName!.isEmpty) return;

      final tokenResult = await UserCaseState().liveSellerUserCase.getToken(
        channleName: state.channelName!,
      );

      tokenResult.handle(
        onSuccess: (tokenData) async {
          final String newToken = (tokenData['token']['token']).toString();
          if (newToken.isNotEmpty && _engine != null) {
            await _engine!.renewToken(newToken);
            emit(state.copyWith(token: newToken));
          }
        },
        onFailed: (message, code) {
          log('renew token failed: $message');
        },
      );
    } catch (e) {
      log('renew token error: $e');
    }
  }

  Future<void> leaveLive() async {
    try {
      if (_engine != null) {
        await _engine!.leaveChannel();
      }
      emit(
        state.copyWith(
          status: CustomerLiveStatus.initial,
          isJoined: false,
          isLiveEnded: false,
          clearRemoteUid: true,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerLiveStatus.error,
          errorMessage: 'حدث خطأ أثناء مغادرة البث',
        ),
      );
    }
  }

  Future<void> disposeEngine() async {
    try {
      if (_engine != null) {
        await _engine!.leaveChannel();
        await _engine!.release();
        _engine = null;
      }
    } catch (_) {}
  }

  RtcEngine? get engine => _engine;
}
