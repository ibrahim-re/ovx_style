import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOffersScreen extends StatelessWidget {
  final navigator;

  const MyOffersScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myOffers = context.read<OfferBloc>().getMyOffers();
    return Scaffold(
      appBar: AppBar(
        title: Text('my offers'.tr()),
      ),
      body: OffersListView(
        fetchedOffers: myOffers,
      ),
    );
  }
}
