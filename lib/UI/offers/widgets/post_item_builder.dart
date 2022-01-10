// offer type= post
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:shimmer_image/shimmer_image.dart';

class PostItemBuilder extends StatelessWidget {
  final postOffer;

  const PostItemBuilder({Key? key, required this.postOffer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
                  imageError: 'assets/images/default_profile.png',
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
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
