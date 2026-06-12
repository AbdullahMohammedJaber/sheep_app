// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/live/live_commint_model.dart';
import 'package:sheep/core/server/servise.dart';
import 'package:sheep/features/live/live_comments_signalr_service.dart';
import 'package:sheep/managment/live/live_comments_cubit.dart';
import 'package:sheep/managment/live/live_comments_state.dart';

import 'package:sheep/managment/live/live_seller_cubit.dart';
import 'package:sheep/managment/live/live_seller_state.dart';
import 'package:sheep/util/message_flash.dart';

 

class SellerLiveBroadcastPage extends StatelessWidget {
  const SellerLiveBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sellerState = context.read<SellerLiveCubit>().state;

    final liveStreamId = int.tryParse(sellerState.liveId.toString()) ?? 0;
    final channelName = sellerState.channelName ?? 'test1';

     

    return BlocProvider(
      create: (_) => LiveCommentsCubit(
        LiveCommentsService()
        
      )..connect(
          baseUrl: ApiService.url,
          channelName: channelName,
          liveStreamId: liveStreamId,
        ),
      child: const _SellerLiveBroadcastView(),
    );
  }
}

class _SellerLiveBroadcastView extends StatelessWidget {
  const _SellerLiveBroadcastView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SellerLiveCubit, SellerLiveState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null &&
              current.errorMessage!.isNotEmpty,
          listener: (context, state) {
            showMessage(state.errorMessage!, value: false);
            context.read<SellerLiveCubit>().clearMessages();
          },
        ),
        BlocListener<LiveCommentsCubit, LiveCommentsState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null &&
              current.errorMessage!.isNotEmpty,
          listener: (context, state) {
            showMessage(state.errorMessage!, value: false);
            context.read<LiveCommentsCubit>().clearError();
          },
        ),
      ],
      child: BlocBuilder<SellerLiveCubit, SellerLiveState>(
        builder: (context, sellerState) {
          final cubit = context.read<SellerLiveCubit>();

          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _LocalBroadcastView(
                      engine: cubit.engine,
                      isCameraOn: sellerState.isCameraOn,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LiveBadge(
                          viewerCount:
                              context.select<LiveCommentsCubit, int>(
                                (cubit) => cubit.state.viewerCount,
                              ),
                        ),
                        const Spacer(),
                        _RightControls(cubit: cubit, state: sellerState),
                      ],
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    right: 12,
                    bottom: 78,
                    child: _CommentsOverlay(),
                  ),
                  const Positioned(
                    bottom: 10,
                    left: 5,
                    right: 5,
                    child: LiveCommentInput(),
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

class _LiveBadge extends StatelessWidget {
  final int viewerCount;

  const _LiveBadge({
    required this.viewerCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'مباشر',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        
      ],
    );
  }
}

class _RightControls extends StatelessWidget {
  final SellerLiveCubit cubit;
  final SellerLiveState state;

  const _RightControls({
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CircleBtn(
          icon: Icons.close,
          onTap: cubit.endLive,
        ),
        const SizedBox(height: 12),
        _CircleBtn(
          icon: state.isCameraOn
              ? Icons.videocam_outlined
              : Icons.videocam_off_outlined,
          onTap: cubit.toggleCamera,
        ),
        const SizedBox(height: 12),
        _CircleBtn(
          icon: state.isMicOn
              ? Icons.mic_none_rounded
              : Icons.mic_off_rounded,
          onTap: cubit.toggleMic,
        ),
        const SizedBox(height: 12),
        _CircleBtn(
          icon: Icons.cameraswitch_outlined,
          onTap: cubit.switchCamera,
        ),
      ],
    );
  }
}
class _CommentsOverlay extends StatelessWidget {
  const _CommentsOverlay();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: BlocBuilder<LiveCommentsCubit, LiveCommentsState>(
        builder: (context, state) {
          final comments = state.comments;

          if (comments.isEmpty) {
            return const SizedBox.shrink();
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.72, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.zero,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final reversedIndex = comments.length - 1 - index;
                  final comment = comments[reversedIndex];

                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 280),
                    tween: Tween(begin: 0.85, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _CommentBubble(comment: comment),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
class _CommentBubble extends StatelessWidget {
  final LiveCommentModel comment;

  const _CommentBubble({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.38),
          borderRadius: BorderRadius.circular(18),
        ),
        child: RichText(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            children: [
              TextSpan(
                text: '${comment.userName}: ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: comment.message,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveCommentInput extends StatefulWidget {
  const LiveCommentInput({super.key});

  @override
  State<LiveCommentInput> createState() => _LiveCommentInputState();
}

class _LiveCommentInputState extends State<LiveCommentInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    FocusScope.of(context).unfocus();
    await context.read<LiveCommentsCubit>().sendComment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LiveCommentsCubit, LiveCommentsState>(
      listenWhen: (previous, current) =>
          previous.currentMessage != current.currentMessage,
      listener: (context, state) {
        if (_controller.text != state.currentMessage) {
          _controller.value = TextEditingValue(
            text: state.currentMessage,
            selection: TextSelection.collapsed(
              offset: state.currentMessage.length,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white),
                onChanged: context.read<LiveCommentsCubit>().onMessageChanged,
                onSubmitted: (_) => _submitComment(),
                decoration: InputDecoration(
                  hintText: "أضف تعليق...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.6),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _submitComment,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalBroadcastView extends StatelessWidget {
  final RtcEngine? engine;
  final bool isCameraOn;

  const _LocalBroadcastView({
    required this.engine,
    required this.isCameraOn,
  });

  @override
  Widget build(BuildContext context) {
    if (engine == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!isCameraOn) {
      return Container(
        color: const Color(0xFF111111),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, color: Colors.white70, size: 60),
            SizedBox(height: 12),
            Text(
              'الكاميرا مغلقة',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine!,
        canvas: const VideoCanvas(uid: 0),
        useAndroidSurfaceView: Platform.isAndroid,
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Future<void> Function() onTap;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.45),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 58,
          height: 58,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}