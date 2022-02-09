import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/UI/offers/offers_screen.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_states.dart';

class NotificationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => NamedNavigatorImpl().push(NamedRoutes.NOTIFICATIONS_SCREEN),
      icon: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (ctx, state) {
          int notificationsCount = context.read<NotificationsBloc>().notifications.length;

          return iconBadge(
            child: SvgPicture.asset('assets/images/notifications.svg'),
            badgeNumber: notificationsCount,
          );
        },
      ),
    );
  }
}
