import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyLikedOffersScreen extends StatelessWidget {
  final navigator;

  const MyLikedOffersScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myLikedOffers = context.read<OfferBloc>().getMyLikedOffers();
    return Scaffold(
      appBar: AppBar(
        title: Text('my liked offers'.tr()),
      ),
      body: OffersListView(
        fetchedOffers: myLikedOffers,
      ),
    );
  }
}
