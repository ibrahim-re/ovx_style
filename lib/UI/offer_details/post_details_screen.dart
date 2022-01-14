import 'package:flutter/material.dart';
import 'package:ovx_style/UI/offer_details/img_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/widget/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/offer.dart';

class postDetails extends StatelessWidget {
  final navigator;
  final PostOffer postOffer;
  const postDetails({Key? key, this.navigator, required this.postOffer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              NamedNavigatorImpl().push(NamedRoutes.HOME_SCREEN, clean: true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.lightBlue,
            )),
      ),
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
              Icon(
                Icons.more_vert,
                color: MyColors.lightBlue,
              ),
            ],
          ),
          const SizedBox(height: 10),
          AddCommentSection(offerId: postOffer.id!),
          UsersComments(
            offerId: postOffer.id!,
            usersComment: postOffer.comments ?? [],
          ),
        ],
      ),
    );
  }
}
