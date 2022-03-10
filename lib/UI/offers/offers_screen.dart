import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/UI/widgets/basket_icon.dart';
import 'package:ovx_style/UI/widgets/notification_icon.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:badges/badges.dart';

class OffersScreen extends StatefulWidget {
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  @override
  void initState() {
    context.read<OfferBloc>().add(FetchOffers(UserType.Person));
    context.read<NotificationsBloc>().add(FetchNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('offers'.tr()),
        actions: [
          //notification icon
          NotificationIcon(),

          //basket icon
          BasketIcon(),

          //filter icon
          IconButton(
            onPressed: () {
              ModalSheets().showFilters(context);
            },
            icon: SvgPicture.asset('assets/images/filter.svg'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: MyColors.secondaryColor,
        onRefresh: () async {
          context.read<OfferBloc>().add(FetchOffers(UserType.Person));
        },
        child: BlocBuilder<OfferBloc, OfferState>(
          builder: (ctx, state) {
            if (state is FetchOffersLoading)
              return WaitingOffersListView();
            else if (state is FetchOffersSucceed)
              return OffersListView(fetchedOffers: state.fetchedOffers);
            else if (state is FetchOffersFailed)
              return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ));
            else
              return Container();
          },
        ),
      ),
    );
  }
}

Widget iconBadge({required Widget child, required int badgeNumber}) {
  return Badge(
    badgeColor: Colors.blue.withOpacity(0.4),
    badgeContent: Text(
      badgeNumber.toString(),
      style: TextStyle(fontSize: 10, color: MyColors.primaryColor),
    ),
    padding: const EdgeInsets.all(6),
    showBadge: true,
    position: BadgePosition(
      isCenter: false,
      top: -12,
      start: -6,
    ),
    child: child,
  );
}
