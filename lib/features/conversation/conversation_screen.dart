// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/managment/chat/chat_cubit.dart';
import 'package:sheep/managment/chat/chat_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/widgets/custom_text.dart';
import 'package:sheep/features/conversation/conversation_empty.dart';
import 'package:sheep/features/conversation/conversation_item.dart';
import 'package:sheep/main.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatCubit>().fetchChats();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<ChatCubit>().refreshChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 1),
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen:
            (previous, current) =>
                previous.error != current.error &&
                current.error != null &&
                current.error!.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
          context.read<ChatCubit>().clearError();
        },
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            final conversations = state.conversations;
            final isLoading =
                state.conversationsStatus == RequestStatus.loading;
            final isFailure =
                state.conversationsStatus == RequestStatus.failure;
            final isEmpty =
                conversations.isEmpty &&
                state.conversationsStatus == RequestStatus.success;

            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: hi * 0.02),
                  const CustomText(
                    text: "المحادثات",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  SizedBox(height: hi * 0.02),

                  if (isLoading)
                    Expanded(
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return const ConversationItemShimmer();
                        },
                      ),
                    )
                  else if (isEmpty)
                    const Expanded(child: ConversationEmpty())
                  else if (isFailure && conversations.isEmpty)
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(
                              child: CustomText(
                                text: 'تعذر تحميل المحادثات',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];

                            return ConversationItem(
                              conversationItemResponse: conversation,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
