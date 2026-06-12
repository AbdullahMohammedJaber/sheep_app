import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sheep/core/user_case_state/user_case_state.dart';
import 'package:sheep/features/seller/root/root_seller_screen.dart';
import 'package:sheep/util/message_flash.dart';
import 'package:sheep/util/route.dart';

import 'live_seller_state.dart';

class SellerLiveCubit extends Cubit<SellerLiveState> {
  SellerLiveCubit() : super(const SellerLiveState());

  static const String agoraAppId = 'd20905f569bc4127addb1684ddfdc0c0';

  RtcEngine? _engine;
  RtcEngine? get engine => _engine;

  void onTitleChanged(String value) {
    emit(state.copyWith(title: value, clearError: true, clearSuccess: true));
  }

  void onDescriptionChanged(String value) {
    emit(
      state.copyWith(description: value, clearError: true, clearSuccess: true),
    );
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  Future<void> initPreview() async {
    if (state.isPreviewReady || state.status == SellerLiveStatus.preparing) {
      return;
    }

    emit(
      state.copyWith(
        status: SellerLiveStatus.preparing,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final granted = await _requestPermissions();
      if (!granted) {
        emit(
          state.copyWith(
            status: SellerLiveStatus.error,
            errorMessage: 'يجب السماح بالكاميرا والمايك لعرض المعاينة',
          ),
        );
        return;
      }

      _engine = createAgoraRtcEngine();

      await _engine!.initialize(
        const RtcEngineContext(
          appId: agoraAppId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            emit(
              state.copyWith(
                status: SellerLiveStatus.live,
                isJoined: true,
                channelName:
                    connection.channelId?.isNotEmpty == true
                        ? connection.channelId
                        : state.channelName,
                uid: connection.localUid,
                successMessage: 'تم الدخول إلى البث بنجاح',
                clearError: true,
              ),
            );
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            emit(
              state.copyWith(
                status: SellerLiveStatus.previewReady,
                isJoined: false,
                clearError: true,
                clearSuccess: true,
              ),
            );
          },
          onError: (ErrorCodeType err, String msg) {
            emit(
              state.copyWith(
                status: SellerLiveStatus.error,
                errorMessage:
                    'Agora error: ${err.name} ${msg.isNotEmpty ? "- $msg" : ""}',
                clearSuccess: true,
              ),
            );
          },
          onConnectionStateChanged: (
            RtcConnection connection,
            ConnectionStateType stateType,
            ConnectionChangedReasonType reason,
          ) {
            // مفيد للتشخيص لاحقًا إذا أحببت
          },
        ),
      );

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      await _engine!.enableVideo();
      await _engine!.enableAudio();

      await _engine!.muteLocalVideoStream(!state.isCameraOn);
      await _engine!.muteLocalAudioStream(!state.isMicOn);

      await _engine!.startPreview();

      emit(
        state.copyWith(
          status: SellerLiveStatus.previewReady,
          isPreviewReady: true,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          isPreviewReady: false,
          errorMessage: 'فشل في تهيئة معاينة الكاميرا',
        ),
      );
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final statuses =
          await [Permission.camera, Permission.microphone].request();

      return (statuses[Permission.camera]?.isGranted ?? false) &&
          (statuses[Permission.microphone]?.isGranted ?? false);
    }
    return true;
  }

  Future<void> toggleCamera() async {
    if (_engine == null) return;

    final newValue = !state.isCameraOn;

    try {
      await _engine!.muteLocalVideoStream(!newValue);

      if (state.isJoined) {
        await _engine!.updateChannelMediaOptions(
          ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            publishCameraTrack: newValue,
            publishMicrophoneTrack: state.isMicOn,
            autoSubscribeAudio: true,
            autoSubscribeVideo: true,
          ),
        );
      }

      emit(
        state.copyWith(
          isCameraOn: newValue,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'تعذر تغيير حالة الكاميرا',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> toggleMic() async {
    if (_engine == null) return;

    final newValue = !state.isMicOn;

    try {
      await _engine!.muteLocalAudioStream(!newValue);

      if (state.isJoined) {
        await _engine!.updateChannelMediaOptions(
          ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            publishCameraTrack: state.isCameraOn,
            publishMicrophoneTrack: newValue,
            autoSubscribeAudio: true,
            autoSubscribeVideo: true,
          ),
        );
      }

      emit(
        state.copyWith(isMicOn: newValue, clearError: true, clearSuccess: true),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'تعذر تغيير حالة المايك',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;

    try {
      await _engine!.switchCamera();
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'تعذر تبديل الكاميرا',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> startLive() async {
    if (!state.isPreviewReady || _engine == null) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'لم يتم تجهيز المعاينة بعد',
          clearSuccess: true,
        ),
      );
      return;
    }
    if (state.title.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'يرجى إدخال عنوان البث',
          clearSuccess: true,
        ),
      );
      return;
    }

    if (state.description.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'يرجى إدخال وصف البث',
          clearSuccess: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: SellerLiveStatus.starting,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final startResult = await UserCaseState().liveSellerUserCase.startLive(
        describtion: state.description,
        title: state.title,
      );

      startResult.handle(
        onSuccess: (startData) async {
          final String channelName = startData['data']['channel_Name'];
          final int id = startData['data']['live_Id'];
          final tokenResult = await UserCaseState().liveSellerUserCase.getToken(
            channleName: channelName,
          );

          tokenResult.handle(
            onSuccess: (tokenData) async {
              final String token = (tokenData['token']['token']).toString();
              final String liveId = (tokenData['token']['live_Id']).toString();
              final String userId = (tokenData['token']['uid']).toString();

              if (token.isEmpty) {
                emit(
                  state.copyWith(
                    status: SellerLiveStatus.error,
                    errorMessage: 'لم يتم استلام التوكن من السيرفر',
                    clearSuccess: true,
                  ),
                );
                return;
              }

              emit(
                state.copyWith(
                  channelName: channelName,
                  token: token,
                  liveId: liveId,
                  clearError: true,
                  clearSuccess: true,
                  id: id,
                ),
              );
              await _engine!.joinChannel(
                token: token,
                channelId: channelName,
                uid: int.parse(userId),
                options: ChannelMediaOptions(
                  clientRoleType: ClientRoleType.clientRoleBroadcaster,
                  publishCameraTrack: state.isCameraOn,
                  publishMicrophoneTrack: state.isMicOn,
                  autoSubscribeAudio: true,
                  autoSubscribeVideo: true,
                ),
              );
            },
            onFailed: (message, code) {
              emit(
                state.copyWith(
                  status: SellerLiveStatus.error,
                  errorMessage: message,
                  clearSuccess: true,
                ),
              );
            },
          );
        },
        onFailed: (message, code) {
          emit(
            state.copyWith(
              status: SellerLiveStatus.error,
              errorMessage: message,
              clearSuccess: true,
            ),
          );
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'حدث خطأ أثناء بدء البث',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> endLive() async {
    emit(
      state.copyWith(
        status: SellerLiveStatus.ending,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      showBoatToast();
      final result = await UserCaseState().liveSellerUserCase.endLive(id: state.id);
      result.handle(
        onSuccess: (data) async {
            if (_engine != null && state.isJoined) {
            await _engine!.leaveChannel();
          }

          await _engine?.muteLocalVideoStream(!state.isCameraOn);
          await _engine?.muteLocalAudioStream(!state.isMicOn);
          emit(
            state.copyWith(
              status: SellerLiveStatus.previewReady,
              isJoined: false,
              liveId: null,
              channelName: null,
              token: null,
              uid: null,
              successMessage: 'تم إنهاء البث',
              clearError: true,
            ),
          );
          toRemoveAll(RootSellerScreen());
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SellerLiveStatus.error,
          errorMessage: 'حدث خطأ أثناء إنهاء البث',
        ),
      );
    }
  }

  Future<void> disposeAgora() async {
    try {
      if (_engine != null) {
        if (state.isJoined) {
          await _engine!.leaveChannel();
        }
        await _engine!.stopPreview();
        await _engine!.release();
      }
      _engine = null;
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await disposeAgora();
    return super.close();
  }
}
