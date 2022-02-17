import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/points_item.dart';
import 'package:ovx_style/UI/profile/widgets/profit_item.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_bloc.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_states.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_bloc.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_events.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_states.dart';
import 'package:ovx_style/bloc/points_bloc/points_bloc.dart';
import 'package:provider/src/provider.dart';

import 'gift_item.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            SharedPref.getUser().userName ?? '',
            style: Constants.TEXT_STYLE4,
          ),
          const SizedBox(height: 6),
          Text(
            SharedPref.getUser().userCode ?? '',
            style: Constants.TEXT_STYLE4
                .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                if(SharedPref.getUser().userType != UserType.Guest.toString())
                  InfoItem(
                    title: 'offers'.tr(),
                    number: SharedPref.getUser().offersAdded?.length ?? 0,
                    route: NamedRoutes.MY_OFFERS_SCREEN,
                  ),
                if(SharedPref.getUser().userType != UserType.Guest.toString())
                  Container(
                    width: 1,
                    height: 40,
                    color: MyColors.lightGrey,
                  ),
                InfoItem(
                  title: 'likes'.tr(),
                  number: SharedPref.getUser().offersLiked?.length ?? 0,
                  route: NamedRoutes.MY_LIKED_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                if(SharedPref.getUser().userType != UserType.Guest.toString())
                  BlocListener<CurrencyBloc, CurrencyState>(
                    listener: (context, state) {
                      if (state is CurrencyChanged)
                        context.read<BillsBloc>().add(FetchBills());
                    },
                    child: ProfitItem(),
                  ),
                if(SharedPref.getUser().userType != UserType.Guest.toString())
                  Container(
                    width: 1,
                    height: 40,
                    color: MyColors.lightGrey,
                  ),
                GiftItem(),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                if(SharedPref.getUser().userType != UserType.Guest.toString())
                  BlocProvider(
                    create: (context) => PointsBloc(),
                    child: PointsItem(),
                  ),
              ],
            ),
          ),
          if(SharedPref.getUser().userType != UserType.Guest.toString())
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                SharedPref.getUser().shortDesc ?? '',
                textAlign: TextAlign.center,
                style: Constants.TEXT_STYLE4,
              ),
            ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final int number;
  final String route;

  InfoItem({
    required this.title,
    required this.number,
    required this.route,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: route.isNotEmpty ? () {
          NamedNavigatorImpl().push(route);
        } : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                title,
                style: Constants.TEXT_STYLE6,
              ),
            ),
            Expanded(
              child: Text(
                number.toString(),
                style: Constants.TEXT_STYLE4.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






