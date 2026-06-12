// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sheep/core/server/servise.dart';
import 'package:sheep/managment/chat/chat_cubit.dart';
import 'package:sheep/managment/chat/chat_state.dart';
import 'package:sheep/util/constants/app_assets.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/message_flash.dart';

enum ChatEntryType { fromProduct, fromConversationList }

class ChatScreen extends StatefulWidget {
  final ChatEntryType entryType;
  final int? sellerId;
  final int? conversationId;
  final String sellerName;

  const ChatScreen({
    super.key,
    required this.entryType,
    required this.sellerName,
    this.sellerId,
    this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const String _receiveEventName = 'ReceiveMessage';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final chatCubit = context.read<ChatCubit>();

      if (widget.entryType == ChatEntryType.fromProduct) {
        if (widget.sellerId == null) return;

        await chatCubit.initChat(
          sellerId: widget.sellerId!,
          hubBaseUrl: ApiService.url,
          receiveEventName: _receiveEventName,
        );
      } else {
        if (widget.conversationId == null) return;

        await chatCubit.openExistingConversation(
          conversationId: widget.conversationId!,
          hubBaseUrl: ApiService.url,
          receiveEventName: _receiveEventName,
        );
      }

      _scrollToBottom(animated: false);
    });
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(position);
      }
    });
  }

  Future<void> _sendMessage() async {
    await context.read<ChatCubit>().sendMessage();
  }

  @override
  void dispose() {
    context.read<ChatCubit>().resetActiveChat();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(
          listenWhen: (p, c) =>
              p.error != c.error && c.error != null && c.error!.isNotEmpty,
          listener: (context, state) {
            showMessage(state.error!, value: false);
            context.read<ChatCubit>().clearError();
          },
        ),
        BlocListener<ChatCubit, ChatState>(
          listenWhen: (p, c) =>
              p.messages.length != c.messages.length ||
              p.currentMessage != c.currentMessage ||
              p.messagesStatus != c.messagesStatus,
          listener: (context, state) {
            final firstLoadDone = state.messagesStatus == RequestStatus.success &&
                state.messages.isNotEmpty;

            if (firstLoadDone) {
              _scrollToBottom(animated: false);
            } else {
              _scrollToBottom();
            }

            if (_controller.text != state.currentMessage) {
              _controller.value = TextEditingValue(
                text: state.currentMessage,
                selection: TextSelection.collapsed(
                  offset: state.currentMessage.length,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF0F4F3),
        body: SafeArea(
          child: Column(
            children: [
              _ChatAppBar(sellerName: widget.sellerName),
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    final isMessagesLoading =
                        state.messagesStatus == RequestStatus.loading;

                    final isHubConnecting =
                        state.messagesStatus == RequestStatus.success &&
                            state.hubStatus == HubConnectionStatus.connecting;

                    final isHubFailed =
                        state.messagesStatus == RequestStatus.success &&
                            state.hubStatus == HubConnectionStatus.failure;

                    if (isMessagesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (isHubConnecting) {
                      return Column(
                        children: [
                          if (state.messages.isNotEmpty)
                            Expanded(
                              child: _MessagesList(
                                scrollController: _scrollController,
                                messages: state.messages,
                              ),
                            )
                          else
                            const Expanded(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: const Text(
                              'جاري الاتصال بالدردشة المباشرة...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (isHubFailed) {
                      return Column(
                        children: [
                          Expanded(
                            child: state.messages.isEmpty
                                ? const Center(
                                    child: Text(
                                      'تم تحميل الرسائل ولكن تعذر الاتصال بالدردشة المباشرة',
                                    ),
                                  )
                                : _MessagesList(
                                    scrollController: _scrollController,
                                    messages: state.messages,
                                  ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'تعذر الاتصال بالدردشة المباشرة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<ChatCubit>().retryConnectHub(
                                            receiveEventName:
                                                _receiveEventName,
                                          );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'إعادة المحاولة',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Text('لا توجد رسائل بعد'),
                      );
                    }

                    return _MessagesList(
                      scrollController: _scrollController,
                      messages: state.messages,
                    );
                  },
                ),
              ),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return _InputBar(
                    controller: _controller,
                    onChanged: context.read<ChatCubit>().onMessageChanged,
                    onSend: _sendMessage,
                    enabled: state.canSend,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<ChatUiMessage> messages;

  const _MessagesList({
    required this.scrollController,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _MessageBubble(message: msg);
      },
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final String sellerName;

  const _ChatAppBar({required this.sellerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        right: 16,
        left: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: SvgPicture.asset(AppAssets.arrowLeft),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              sellerName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatUiMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    final bool isMine = message.isMine;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              GestureDetector(
                onTap: message.deliveryStatus == ChatMessageDeliveryStatus.failed
                    ? () => context.read<ChatCubit>().retryMessage(
                          message.localId,
                        )
                    : null,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 78,
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMine
                        ? _bubbleColor(message.deliveryStatus)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMine
                          ? const Radius.circular(18)
                          : const Radius.circular(6),
                      bottomRight: isMine
                          ? const Radius.circular(6)
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMine
                            ? AppColors.primary.withOpacity(0.20)
                            : Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.5,
                      color: isMine ? Colors.white : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              _MessageMetaInline(
                isMine: isMine,
                timeText: cubit.formatMessageTime(message.createdAt),
                deliveryStatus: message.deliveryStatus,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _bubbleColor(ChatMessageDeliveryStatus status) {
    switch (status) {
      case ChatMessageDeliveryStatus.sending:
        return AppColors.primary.withOpacity(0.58);
      case ChatMessageDeliveryStatus.failed:
        return const Color(0xFFD96B6B);
      case ChatMessageDeliveryStatus.sent:
        return AppColors.primary;
    }
  }
}

class _MessageMetaInline extends StatelessWidget {
  final bool isMine;
  final String timeText;
  final ChatMessageDeliveryStatus deliveryStatus;

  const _MessageMetaInline({
    required this.isMine,
    required this.timeText,
    required this.deliveryStatus,
  });

  @override
  Widget build(BuildContext context) {
    const Color timeColor = Color(0xFF9E9E9E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            timeText,
            style: const TextStyle(
              fontSize: 11,
              color: timeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: 6),
            _DeliveryIndicator(status: deliveryStatus),
          ],
        ],
      ),
    );
  }
}

class _DeliveryIndicator extends StatelessWidget {
  final ChatMessageDeliveryStatus status;

  const _DeliveryIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ChatMessageDeliveryStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.6,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE0A100)),
          ),
        );
      case ChatMessageDeliveryStatus.failed:
        return const Icon(
          Icons.error_outline_rounded,
          size: 14,
          color: Color(0xFFD32F2F),
        );
      case ChatMessageDeliveryStatus.sent:
        return const Icon(
          Icons.done_all_rounded,
          size: 14,
          color: AppColors.primary,
        );
    }
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final Future<void> Function() onSend;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 16,
          left: 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             
            Row(
              children: [
                // _BarIcon(
                //   icon: Icons.attach_file_rounded,
                //   onTap: () {},
                //   color: const Color(0xFF9E9E9E),
                // ),
                // const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: enabled
                          ? const Color(0xFFF5F5F5)
                          : const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 0.8,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      enabled: enabled,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 4,
                      minLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'أرسل رسالة جديدة ...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {});
                      },
                      onChanged: enabled ? onChanged : null,
                      onSubmitted: enabled ? (_) => onSend() : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: enabled ? onSend : null,
                  child: Opacity(
                    opacity: enabled ? 1 : 0.5,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _BarIcon({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF5F5F5),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}