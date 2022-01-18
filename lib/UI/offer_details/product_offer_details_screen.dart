import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/featues_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/product_image_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/properties_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/ship_to_section.dart';
import 'package:ovx_style/UI/offer_details/widget/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          OfferOwnerRow(
            offerOwnerId: offer.offerOwnerId,
            offerId: offer.id,
          ),
          ProductImageSection(
            offerOwnerId: offer.offerOwnerId!,
            productImages: offer.offerMedia!,
            categories: offer.categories!,
            description: offer.shortDesc!,
            status: offer.status!,
            properties: offer.properties!,
          ),
          PropertiesSection(
            offerProperties: offer.properties!,
            discount: offer.discount!,
            title: offer.offerName!,
            image: offer.offerMedia!.first,
          ),
          featuresSection(
            isReturnAvailable: offer.isReturnAvailable!,
            isShippingFree: offer.isShippingFree!,
          ),
          ShipToSection(
            shippingCosts: offer.shippingCosts!,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.secondaryColor,
        onPressed: () {
          NamedNavigatorImpl().push(
            NamedRoutes.Basket,
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
    );
  }
}
