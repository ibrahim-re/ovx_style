import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/notifications/widgets/notification_item.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_states.dart';

class NotificationsScreen extends StatelessWidget {
  final navigator;

  NotificationsScreen({this.navigator});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr()),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if(state is NotificationsLoading)
            return Center(child: CircularProgressIndicator(color: MyColors.secondaryColor,),);

          else if(state is NotificationsFetched)
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: state.notifications.length,
                separatorBuilder: (ctx, index) => const SizedBox(height: 12,),
                itemBuilder: (ctx, index) => NotificationItem(
                  id: state.notifications[index].id!,
                  title: state.notifications[index].title!,
                  content: state.notifications[index].content!,
                  date: state.notifications[index].date!,
                ),
              ),
            );

          else if(state is NotificationsFailed)
            return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColors.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            );

          else
            return Container();
        },
      ),
    );
  }
}

