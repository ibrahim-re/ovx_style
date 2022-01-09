// offer type= image

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:shimmer_image/shimmer_image.dart';

class ImageItemBuilder extends StatelessWidget {
  final imageOffer;

  const ImageItemBuilder({Key? key, required this.imageOffer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            height: 70,
            child: OfferOwnerRow(
              offerOwnerId: imageOffer.offerOwnerId,
              offerId: imageOffer.id,
            ),
          ),
          //video Container
          Container(
            alignment: Alignment.center,
            width: screenWidth,
            height: screenHeight * 0.30,
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: imageOffer.offerMedia.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (ctx, index) => SizedBox(
                    width: 6,
                  ),
                  itemBuilder: (ctx, index) => ProgressiveImage(
                    imageError: 'assets/images/default_profile.png',
                    image: imageOffer.offerMedia[index],
                    width: screenWidth,
                    height: screenHeight * 0.30,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                if(imageOffer.offerMedia.length > 1)
                  Positioned(
                    bottom: 0,
                    right: 8,
                    child: Chip(
                      backgroundColor: MyColors.lightGrey,
                      label: Text(
                        '${imageOffer.offerMedia.length} photos',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: MyColors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}