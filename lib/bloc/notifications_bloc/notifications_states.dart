import 'package:ovx_style/model/notification.dart';

class NotificationsState {}

class NotificationsInitialized extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsFetched extends NotificationsState {
  List<MyNotification> notifications;

  NotificationsFetched(this.notifications);
}

class NotificationsFailed extends NotificationsState {
  String message;

  NotificationsFailed(this.message);
}
