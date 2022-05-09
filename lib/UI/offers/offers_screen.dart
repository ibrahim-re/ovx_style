import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/UI/widgets/basket_icon.dart';
import 'package:ovx_style/UI/widgets/filter_icon.dart';
import 'package:ovx_style/UI/widgets/notification_icon.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:badges/badges.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/offer.dart';

class OffersScreen extends StatefulWidget {
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final scrollController = ScrollController();
  //for pagination
  String _lastFetchedOfferId = '';

  @override
  void initState() {
    context.read<OfferBloc>().add(FetchOffers(UserType.User));
    context.read<NotificationsBloc>().add(FetchNotifications());
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        context
            .read<OfferBloc>()
            .add(FetchMoreOffers(UserType.User, _lastFetchedOfferId));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
          FilterIcon(ontap: () {
            ModalSheets().showFilters(context, UserType.User);
          }),
        ],
      ),
      body: RefreshIndicator(
        color: MyColors.secondaryColor,
        onRefresh: () async {
          context.read<OfferBloc>().add(FetchOffers(UserType.User));
        },
        child: BlocBuilder<OfferBloc, OfferState>(
          builder: (ctx, state) {
            if (state is FetchOffersLoading ||
                state is OfferStateInitial ||
                state is GetFilteredOffersLoading)
              return WaitingOffersListView();
            else if (state is FetchOffersFailed)
              return Center(
                  child: Text(
                state.message,
                style: Constants.TEXT_STYLE9,
              ));
            else if (state is GetFilteredOffersFailed)
              return Center(
                  child: Text(
                state.message,
                style: Constants.TEXT_STYLE9,
              ));
            else if (state is GetFilteredOffersDone)
              return OffersListView(fetchedOffers: state.offers);
            else {
              List<Offer> offers = context.read<OfferBloc>().fetchedOffers;
              if (offers.isEmpty)
                return Center(
                  child: Text(
                    'no offer yet'.tr(),
                    style: Constants.TEXT_STYLE9,
                  ),
                );
              else {
                _lastFetchedOfferId = offers.last.id ?? '';
                return Column(
                  children: [
                    Expanded(
                      child: OffersListView(
                        fetchedOffers: offers,
                        scrollController: scrollController,
                      ),
                    ),
                    state is FetchMoreOffersLoading
                        ? Center(
                            child: RefreshProgressIndicator(
                              color: MyColors.secondaryColor,
                            ),
                          )
                        : state is FetchMoreOffersFailed
                            ? Center(child: Text('error occurred'.tr()))
                            : Container(),
                  ],
                );
              }
            }
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
