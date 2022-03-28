import 'package:flutter/material.dart';
import 'package:ovx_style/UI/offers/widgets/post_item_builder.dart';
import 'package:ovx_style/UI/offers/widgets/product_item_builder.dart';
import 'package:ovx_style/UI/offers/widgets/video_item_builder.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/offer.dart';
import 'image_item_builder.dart';

class OffersListView extends StatelessWidget {
  final List<Offer> fetchedOffers;
  final scrollPhysics;
  final shrinkWrap;
  final scrollController;
  final child;

  OffersListView({required this.fetchedOffers, this.scrollPhysics, this.shrinkWrap, this.scrollController, this.child});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: scrollPhysics ?? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      shrinkWrap: shrinkWrap ?? false,
      //padding: const EdgeInsets.only(bottom: 20),
      itemCount: fetchedOffers.length + 1,
      itemBuilder: (ctx, index) {
        if(index < fetchedOffers.length){
          if (fetchedOffers[index].offerType == OfferType.Product.toString())
            return ProductItemBuilder(
              productOffer: fetchedOffers[index] as ProductOffer,
            );
          else if (fetchedOffers[index].offerType == OfferType.Post.toString())
            return PostItemBuilder(
              postOffer: fetchedOffers[index],
            );
          else if (fetchedOffers[index].offerType == OfferType.Image.toString())
            return ImageItemBuilder(
              imageOffer: fetchedOffers[index],
            );
          else if (fetchedOffers[index].offerType == OfferType.Video.toString())
            return VideoItemBuilder(
              videoOffer: fetchedOffers[index],
            );
          else
            return Container();
        } else
          return child ?? Container();
      },
    );
  }
}
