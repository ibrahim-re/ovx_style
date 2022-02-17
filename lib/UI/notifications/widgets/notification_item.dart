import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_events.dart';
import 'package:provider/src/provider.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String content, id;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.content,
    required this.date,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        if(title == 'Product Sold'){
          //in case bills is not fetched yet
          context.read<BillsBloc>().add(FetchBills());
          NamedNavigatorImpl().push(NamedRoutes.MY_BILLS_SCREEN);
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(12),
          height: screenHeight * 0.25,
          decoration: BoxDecoration(
            color: MyColors.lightBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  DateFormat('dd MMM yyyy').format(date),
                  style: Constants.TEXT_STYLE7.copyWith(color: MyColors.secondaryColor),
                ),
              ),
              Text(
                title,
                style: Constants.TEXT_STYLE4.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              Expanded(
                child: Text(
                  content,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: Constants.TEXT_STYLE6,
                ),
              ),
              GestureDetector(
                onTap: (){
                  context.read<NotificationsBloc>().add(DeleteNotification(id, SharedPref.getUser().id!));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset('assets/images/trash.svg', fit: BoxFit.scaleDown,),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
