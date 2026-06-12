import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheep/core/data/response/notification/notification_response.dart';
import 'package:sheep/managment/notification/notification_state.dart';
import 'package:sheep/util/enum.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  bool _loading = false;

 
  final int _pageSize = 10;

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (_loading) return;

    if (refresh) {
      emit(state.copyWith(
        status: RequestStatus.loading,
        notifications: [],
        page: 1,
        hasMore: true,
        error: null,
      ));
    }

    if (!state.hasMore) return;

    _loading = true;

    try {
 
      await Future.delayed(const Duration(seconds: 1));

      final List<NotificationModel> newItems = List.generate(
        _pageSize,
        (index) => NotificationModel(
          id: index + (state.page * _pageSize),
          title: "إشعار ${index + 1} - صفحة ${state.page}",
          body: "هذا إشعار تجريبي",
          createdAt: DateTime.now().toString(),
        ),
      );

 
      final bool hasMore = newItems.length == _pageSize;

      emit(
        state.copyWith(
          status: RequestStatus.success,
          notifications: refresh
              ? newItems
              : [...state.notifications, ...newItems],
          page: state.page + 1,
          hasMore: hasMore,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          error: "حدث خطأ",
        ),
      );
    }

    _loading = false;
  }

  void markAsRead(int notificationId) async{
    
  }
}