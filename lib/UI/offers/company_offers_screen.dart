import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';

class CompanyOffersScreen extends StatefulWidget {
 @override
 State<CompanyOffersScreen> createState() => _CompanyOffersScreenState();
}

class _CompanyOffersScreenState extends State<CompanyOffersScreen> {
 @override
 void initState() {
  context.read<OfferBloc>().add(FetchOffers(UserType.Company));
  super.initState();
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text('c.offers'.tr()),
    actions: [
     IconButton(
      onPressed: () {
       ModalSheets().showOfferTypePicker(context);
      },
      icon: SvgPicture.asset('assets/images/notifications.svg'),
     ),
     IconButton(
      onPressed: () {
       ModalSheets().showOfferTypePicker(context);
      },
      icon: SvgPicture.asset('assets/images/cart.svg'),
     ),
     IconButton(
      onPressed: () {
       ModalSheets().showOfferTypePicker(context);
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
      if (state is FetchOffersLoading)
       return WaitingOffersListView();
      else if (state is FetchOffersSucceed)
       return OffersListView(fetchedOffers: state.fetchedOffers,);
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
