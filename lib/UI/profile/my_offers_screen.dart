import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';

class MyOffersScreen extends StatefulWidget {
  final navigator;

  const MyOffersScreen({Key? key, this.navigator}) : super(key: key);

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  void initState() {
    context.read<OfferBloc>().add(GetUserOffers(SharedPref.getUser().id!, SharedPref.getUser().userType!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my offers'.tr()),
      ),
      body: BlocBuilder<OfferBloc, OfferState>(builder: (ctx, state) {
        if (state is GetUserOffersFailed)
          return Center(
            child: Text(state.message, style: Constants.TEXT_STYLE9),
          );
        else if (state is GetUserOffersDone) {
          if (state.offers.isNotEmpty)
            return OffersListView(
              fetchedOffers: state.offers,
            );
          else
            return Center(
              child: Text(
                'no added offers yet'.tr(),
                style: Constants.TEXT_STYLE8.copyWith(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
        } else
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.secondaryColor,
            ),
          );
      }),
    );
  }
}
