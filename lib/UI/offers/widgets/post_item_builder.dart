// offer type= post
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:shimmer_image/shimmer_image.dart';

class PostItemBuilder extends StatelessWidget {
  final postOffer;

  const PostItemBuilder({Key? key, required this.postOffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        NamedNavigatorImpl().push(
          NamedRoutes.Post_Details,
          arguments: {'post': postOffer},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OfferOwnerRow(
              offerOwnerId: postOffer.offerOwnerId,
              offerId: postOffer.id,
            ),
            if (postOffer.offerMedia.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: double.infinity,
                height: screenHeight * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: ProgressiveImage(
                    imageError: 'assets/images/no_internet.png',
                    image: postOffer.offerMedia.first,
                    width: double.infinity,
                    height: screenHeight * 0.30,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Text(
              postOffer.shortDesc ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Constants.TEXT_STYLE6,
              // textAlign: TextAlign.justify,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: BlocListener<AddOfferBloc, AddOfferState>(
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
            ),
          ],
        ),
      ),
    );
  }
}
