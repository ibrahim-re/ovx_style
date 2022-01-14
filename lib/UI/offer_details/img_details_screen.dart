import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ovx_style/UI/offer_details/img_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
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
          const SizedBox(height: 10),
          AddCommentSection(
            offerId: offer.id!,
          ),
          UsersComments(
            offerId: offer.id!,
            usersComment: offer.comments ?? [],
          ),
        ],
      ),
    );
  }
}
