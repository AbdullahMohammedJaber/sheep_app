import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/features/auth/widget/widget_auth.dart';
import 'package:sheep/main.dart';
import 'package:sheep/managment/notification/notification_cubit.dart';
import 'package:sheep/managment/notification/notification_state.dart';
import 'package:sheep/util/constants/app_colors.dart';
import 'package:sheep/util/constants/app_strings.dart';
import 'package:sheep/util/enum.dart';
import 'package:sheep/util/widgets/error_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<NotificationsCubit>().fetchNotifications(refresh: true);

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.position.pixels;

    /// 🔥 trigger مضبوط
    if (currentScroll >= maxScroll - 150) {
      context.read<NotificationsCubit>().fetchNotifications();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          SizedBox(height: hi * 0.02),
          arrowLift(context, AppStrings.notifications),
          SizedBox(height: hi * 0.01),
          Divider(color: AppColors.border, thickness: 1),
          SizedBox(height: hi * 0.02),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.status == RequestStatus.loading &&
                    state.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                /// Error
                if (state.status == RequestStatus.failure &&
                    state.notifications.isEmpty) {
                  return AppErrorWidget(
                    message: state.error,
                    onRetry: () {
                      context.read<NotificationsCubit>().fetchNotifications(
                        refresh: true,
                      );
                    },
                  );
                }
            
                /// Empty
                if (state.notifications.isEmpty) {
                  return const Center(child: Text("لا يوجد إشعارات"));
                }
            
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<NotificationsCubit>().fetchNotifications(
                      refresh: true,
                    );
                  },
                  child: ListView.builder(
                    controller: _controller,
                    itemCount:
                        state.notifications.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.notifications.length) {
                        final item = state.notifications[index];
            
                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.body),
                          trailing: Text(item.createdAt),
                        );
                      }
            
                      /// 🔥 loading أسفل الليست
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
