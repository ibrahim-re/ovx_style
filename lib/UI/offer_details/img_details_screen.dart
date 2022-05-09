import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/img_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:provider/src/provider.dart';
import 'widget/add_comment_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/model/offer.dart';

// this screen show the details of the product
class ImageDetailsScreen extends StatelessWidget {
  final navigator;
  final ImageOffer offer;
  const ImageDetailsScreen({this.navigator, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          OfferOwnerRow(
            offerOwnerId: offer.offerOwnerId,
            offerId: offer.id,
          ),
          ImageSection(
            offerImages: offer.offerMedia!,
          ),
          BlocListener<AddOfferBloc, AddOfferState>(
            listener: (ctx, state) {
              if (state is DeleteOfferLoading)
                EasyLoading.show(status: 'please wait'.tr());
              else if(state is DeleteOfferSucceed){
                EasyLoading.showSuccess('offer deleted'.tr());
                NamedNavigatorImpl().pop();
              }
              else if (state is DeleteOfferFailed)
                EasyLoading.showError(state.message);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomPopUpMenu(
                ownerId: offer.offerOwnerId,
                shareFunction: () async {
                  OfferHelper.shareImage(offer.offerMedia!);
                },
                reportFunction: (){
                  String body = 'I want to report this image offer because of: \n\n\n\nOffer ID: ${offer.id}';
                  Helper().sendEmail('Report Image Offer [OVX Style App]', body, []);
                },
                deleteFunction: () {
                  context.read<AddOfferBloc>().add(
                        DeleteOfferButtonPressed(
                            offer.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                      );
                },
              ),
            ),
          ),
          AddCommentSection(
            offerId: offer.id!,
            offerOwnerId: offer.offerOwnerId!,
          ),
          UsersComments(
            offerId: offer.id!,
            offerOwnerId: offer.offerOwnerId!,
          ),
        ],
      ),
    );
  }
}
