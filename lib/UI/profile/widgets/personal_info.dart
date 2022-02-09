import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_bloc.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_events.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_states.dart';
import 'package:provider/src/provider.dart';

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
                InfoItem(
                  title: 'Offers',
                  number: SharedPref.getUser().offersAdded?.length ?? 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Likes',
                  number: SharedPref.getUser().offersLiked?.length ?? 0,
                  route: NamedRoutes.MY_LIKED_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                BlocListener<CurrencyBloc, CurrencyState>(
                  listener: (context, state) {
                    if (state is CurrencyChanged)
                      context.read<BillsBloc>().add(FetchBills());
                  },
                  child: ProfitItem(),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Gifts',
                  number: 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Points',
                  number: SharedPref.getUser().points ?? 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
              ],
            ),
          ),
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
        onTap: () {
          NamedNavigatorImpl().push(route);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Constants.TEXT_STYLE4,
            ),
            Text(
              number.toString(),
              style: Constants.TEXT_STYLE4.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfitItem extends StatefulWidget {
  @override
  State<ProfitItem> createState() => _ProfitItemState();
}

class _ProfitItemState extends State<ProfitItem> {
  @override
  void initState() {
    context.read<BillsBloc>().add(FetchBills());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          NamedNavigatorImpl().push(NamedRoutes.MY_BILLS_SCREEN);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'profit'.tr(),
              style: Constants.TEXT_STYLE4,
            ),
            Expanded(
              child: BlocBuilder<BillsBloc, BillsState>(
                builder: (context, state) {
                  if (state is FetchBillsLoading) {
                    return Center(
                      child: RefreshProgressIndicator(
                        //color: MyColors.secondaryColor,
                      ),
                    );
                  } else if (state is FetchBillsFailed)
                    return Center(
                      child: Text('0'),
                    );
                  else {
                    double total = context.read<BillsBloc>().calculateTotalBillsAmount();
                    return Text(
                      '$total',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
