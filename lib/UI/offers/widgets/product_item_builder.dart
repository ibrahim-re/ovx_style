// offer type= product
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:shimmer_image/shimmer_image.dart';
import 'offer_owner_row.dart';

class ProductItemBuilder extends StatelessWidget {
  final productOffer;

  const ProductItemBuilder({Key? key, @required this.productOffer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // first element [top row]
          OfferOwnerRow(
            offerOwnerId: productOffer.offerOwnerId,
            offerId: productOffer.id,
          ),
          // second element [image]
          GestureDetector(
            onTap: () {
              NamedNavigatorImpl().push(
                NamedRoutes.Product_Details,
                arguments: {'offer': productOffer},
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              width: double.infinity,
              height: screenHeight * 0.30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: ProgressiveImage(
                      imageError: 'assets/images/default_profile.png',
                      image: productOffer.offerMedia.first,
                      width: double.maxFinite,
                      height: screenHeight * 0.30,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('add to cart');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircleAvatar(
                        backgroundColor: MyColors.primaryColor,
                        radius: 20.0,
                        child: SvgPicture.asset(
                          'assets/images/cart.svg',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // third element
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    productOffer.status == OfferStatus.New.toString()
                        ? 'new'.tr()
                        : 'used'.tr(),
                    style: TextStyle(color: MyColors.primaryColor),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        productOffer.shortDesc ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Constants.TEXT_STYLE6,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(width: 4),
                    productOffer.discount == 0
                        ? Text(
                            '${productOffer.properties.first.sizes.first.price} \$',
                            style: TextStyle(
                              fontSize: 18,
                              color: MyColors.secondaryColor,
                            ))
                        : Row(
                            children: [
                              Text(
                                '${productOffer.properties.first.sizes.first.price} \$',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${Helper().priceAfterDiscount(productOffer.properties.first.sizes.first.price, productOffer.discount)} \$',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
