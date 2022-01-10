import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/color_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/descreption_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/featues_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/image_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/ship_to_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/size_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/top_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/users_comments_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/offer.dart';

// this screen show the details of the product
class ProductDetails extends StatelessWidget {
  final navigator;
  final ProductOffer offer;
  const ProductDetails({
    this.navigator,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            OfferOwnerRow(
              offerOwnerId: offer.offerOwnerId,
              offerId: offer.id,
            ),
            imageSection(
              productImages: offer.offerMedia!,
              categories: offer.categories!,
              descreption: offer.shortDesc!,
              status: offer.status!,
              discount: offer.discount!,
              proberties: offer.properties!,
            ),
            colorSection(productColor: offer.properties!.first.color!),
            sizesSection(Sizes: offer.properties!.first.sizes!),
            featuresSection(
              isReturnAvailable: offer.isReturnAvailable!,
              isShippingFree: offer.isShippingFree!,
            ),
            // shipToSection(),
            // addcommentSection(),
            // usersComments(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.secondaryColor,
          onPressed: () {
            NamedNavigatorImpl().push(
              NamedRoutes.Basket,
              clean: true,
            );
          },
          mini: true,
          child: Builder(
            builder: (_) => SvgPicture.asset(
              'assets/images/cart.svg',
              color: MyColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
