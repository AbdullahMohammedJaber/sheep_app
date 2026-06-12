import 'package:sheep/core/data/response/notification/notification_response.dart';
import 'package:sheep/util/enum.dart';

class NotificationsState {
  final RequestStatus status;
  final List<NotificationModel> notifications;
  final String? error;
  final bool hasMore;
  final int page;

  const NotificationsState({
    this.status = RequestStatus.initial,
    this.notifications = const [],
    this.error,
    this.hasMore = true,
    this.page = 1,
  });

  NotificationsState copyWith({
    RequestStatus? status,
    List<NotificationModel>? notifications,
    String? error,
    bool? hasMore,
    int? page,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}