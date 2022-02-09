
class NotificationsEvent {}


class FetchNotifications extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  String id;
  String userId;

  DeleteNotification(this.id, this.userId);
}