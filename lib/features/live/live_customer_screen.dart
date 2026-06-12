// ignore_for_file: deprecated_member_use

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sheep/core/data/response/live/live_commint_model.dart';
import 'package:sheep/core/server/servise.dart';
import 'package:sheep/features/live/live_comments_signalr_service.dart';
import 'package:sheep/managment/live/live_comments_cubit.dart';
import 'package:sheep/managment/live/live_comments_state.dart';
import 'package:sheep/managment/live/live_customer_cubit.dart';
import 'package:sheep/managment/live/live_customer_state.dart';
import 'package:sheep/util/message_flash.dart';

class LiveCustomerScreen extends StatelessWidget {
  final String id;
  final String channelName;

  const LiveCustomerScreen({
    super.key,
    required this.id,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    final int? liveStreamId = int.tryParse(id);

    if (liveStreamId == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'رقم البث غير صحيح',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LiveCustomerCubit()
            ..initAndJoinAsAudience(
              id: id,
              channelName: channelName,
            ),
        ),
        BlocProvider(
          create: (_) => LiveCommentsCubit(
            LiveCommentsService(),
          )..connect(
              baseUrl: ApiService.url,
              channelName: channelName,
              liveStreamId: liveStreamId,
            ),
        ),
      ],
      child: const _LiveCustomerView(),
    );
  }
}

class _LiveCustomerView extends StatefulWidget {
  const _LiveCustomerView();

  @override
  State<_LiveCustomerView> createState() => _LiveCustomerViewState();
}

class _LiveCustomerViewState extends State<_LiveCustomerView> {
  late final LiveCustomerCubit _liveCustomerCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _liveCustomerCubit = context.read<LiveCustomerCubit>();
  }

  @override
  void dispose() {
    _liveCustomerCubit.disposeEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LiveCustomerCubit, LiveCustomerState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              showMessage(state.errorMessage!, value: false);
            }
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
      child: BlocBuilder<LiveCustomerCubit, LiveCustomerState>(
        builder: (context, state) {
          final cubit = context.read<LiveCustomerCubit>();

          return WillPopScope(
            onWillPop: () async {
              await cubit.leaveLive();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildBody(state, cubit),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: _TopBar(
                        onBack: () async {
                          await cubit.leaveLive();
                          if (mounted) Navigator.pop(context);
                        },
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(LiveCustomerState state, LiveCustomerCubit cubit) {
    if (state.status == CustomerLiveStatus.loading ||
        state.status == CustomerLiveStatus.engineInitializing ||
        state.status == CustomerLiveStatus.tokenLoading ||
        state.status == CustomerLiveStatus.joining) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == CustomerLiveStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 50),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'حدث خطأ',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.isLiveEnded || state.status == CustomerLiveStatus.liveEnded) {
      return const Center(
        child: _LiveEndedView(),
      );
    }

    if (state.remoteUid != null && cubit.engine != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: cubit.engine!,
          canvas: VideoCanvas(uid: state.remoteUid),
          connection: RtcConnection(channelId: state.channelName),
        ),
      );
    }

    return const Center(
      child: Text(
        'بانتظار بدء فيديو البائع...',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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

class _LiveEndedView extends StatelessWidget {
  const _LiveEndedView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam_off, color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text(
            'انتهى البث المباشر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}