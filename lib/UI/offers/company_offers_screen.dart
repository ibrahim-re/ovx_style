import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/UI/widgets/basket_icon.dart';
import 'package:ovx_style/UI/widgets/notification_icon.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/model/offer.dart';

class CompanyOffersScreen extends StatefulWidget {
  @override
  State<CompanyOffersScreen> createState() => _CompanyOffersScreenState();
}

class _CompanyOffersScreenState extends State<CompanyOffersScreen> {
  final scrollController = ScrollController();
  //for pagination
  String _lastFetchedOfferId = '';

  @override
  void initState() {
    context.read<OfferBloc>().add(FetchOffers(UserType.Company));
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        context
            .read<OfferBloc>()
            .add(FetchMoreOffers(UserType.Company, _lastFetchedOfferId));
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
        title: Text('c.offers'.tr()),
        actions: [
          //notification icon
          NotificationIcon(),

          //basket icon
          BasketIcon(),

          //filter icon
          IconButton(
            onPressed: () {
              ModalSheets().showFilters(context, UserType.Company);
            },
            icon: SvgPicture.asset('assets/images/filter.svg'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: MyColors.secondaryColor,
        onRefresh: () async {
          context.read<OfferBloc>().add(FetchOffers(UserType.Company));
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
