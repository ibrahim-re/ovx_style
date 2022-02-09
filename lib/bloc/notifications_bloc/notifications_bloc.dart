import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_events.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_states.dart';
import 'package:ovx_style/model/notification.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  List<MyNotification> notifications = [];

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if(event is FetchNotifications){
      yield NotificationsLoading();
      try {
        notifications = await _databaseRepositoryImpl.fetchNotifications(SharedPref.getUser().id!);
        yield NotificationsFetched(notifications);
      } catch (e) {
        print(e.toString());
        yield NotificationsFailed('error occurred'.tr());
      }
    }else if(event is DeleteNotification){
      yield NotificationsLoading();
      try {
        await _databaseRepositoryImpl.deleteNotification(event.id, event.userId);
        notifications.removeWhere((element) => element.id == event.id);
        yield NotificationsFetched(notifications);
      } catch (e) {
        print(e.toString());
        yield NotificationsFailed('error occurred'.tr());
      }
    }
  }
}
