import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/img_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/widget/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:provider/src/provider.dart';

class postDetails extends StatelessWidget {
  final navigator;
  final PostOffer postOffer;
  const postDetails({Key? key, this.navigator, required this.postOffer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(postOffer.comments!.length);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          OfferOwnerRow(
            offerOwnerId: postOffer.offerOwnerId,
            offerId: postOffer.id,
          ),
          if (postOffer.offerMedia!.isNotEmpty)
            ImageSection(offerImages: postOffer.offerMedia!),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    postOffer.shortDesc!,
                    style: Constants.TEXT_STYLE4,
                  ),
                ),
              ),
              BlocListener<AddOfferBloc, AddOfferState>(
                listener: (ctx, state){
                  if(state is DeleteOfferLoading)
                    EasyLoading.show(status: 'please wait'.tr());
                  else if(state is DeleteOfferSucceed){
                    EasyLoading.showSuccess('offer deleted'.tr());
                    NamedNavigatorImpl().pop();
                  }
                  else if(state is DeleteOfferFailed)
                    EasyLoading.showError(state.message);
                },
                child: CustomPopUpMenu(
                ownerId: postOffer.offerOwnerId,
                deleteFunction: () {
                  context.read<AddOfferBloc>().add(
                        DeleteOfferButtonPressed(
                            postOffer.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                      );
                },
              ),),
            ],
          ),
          const SizedBox(height: 10),
          AddCommentSection(
              offerId: postOffer.id!, offerOwnerId: postOffer.offerOwnerId!),
          UsersComments(
            offerId: postOffer.id!,
            offerOwnerId: postOffer.offerOwnerId!,
          ),
        ],
      ),
    );
  }
}
