// offer type= product
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer_image/shimmer_image.dart';
import 'offer_owner_row.dart';
import 'package:http/http.dart' as http;

class ProductItemBuilder extends StatelessWidget {
  final ProductOffer productOffer;

  const ProductItemBuilder({Key? key, required this.productOffer})
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
                      imageError: 'assets/images/no_internet.png',
                      image: productOffer.offerMedia!.first,
                      width: double.infinity,
                      height: screenHeight * 0.30,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      NamedNavigatorImpl().push(
                        NamedRoutes.Product_Details,
                        arguments: {'offer': productOffer},
                      );

                      // //get my country and my shipping cost
                      // String myCountry = SharedPref.getUser().country!;
                      // double shipCost = 0;
                      // for(var key in productOffer.shippingCosts!.keys){
                      //   if(Helper().deleteCountryFlag(key) == myCountry) {
                      //     shipCost = productOffer.shippingCosts![key] ?? 0;
                      //     break;
                      //   }
                      // }
                      // //in case no shipping
                      // // double selectedShippingPrice =
                      // //     productOffer.shippingCosts!.isNotEmpty
                      // //         ? productOffer.shippingCosts![myCountry] ?? 0
                      // //         : 0;
                      // // String shipTo = productOffer.shippingCosts!.isNotEmpty
                      // //     ? productOffer.shippingCosts!.keys.first
                      // //     : '';
                      // //get price and see if there is discount
                      // double price =
                      //     productOffer.properties!.first.sizes!.first.price!;
                      // if (productOffer.discount != 0)
                      //   price = Helper()
                      //       .priceAfterDiscount(price, productOffer.discount!);
                      //
                      // print(myCountry);
                      // //add item to basket
                      // context.read<BasketBloc>().add(
                      //       AddItemToBasketEvent(
                      //         productOffer.id!,
                      //         productOffer.offerOwnerId!,
                      //         productOffer.offerName!,
                      //         productOffer.offerMedia!.first,
                      //         productOffer.properties!.first.sizes!.first.size!,
                      //         price,
                      //         productOffer.properties!.first.color!,
                      //         productOffer.vat ?? 0,
                      //         shipCost,
                      //         myCountry,
                      //       ),
                      //     );
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
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
										Spacer(),
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
												ownerId: productOffer.offerOwnerId,
                        shareFunction: () async {
												  OfferHelper.shareProduct(productOffer.offerMedia!, productOffer.offerName!, productOffer.shortDesc ?? '', productOffer.categories!, productOffer.status!);
                        },
                        reportFunction: (){
                          String body = 'I want to report this product offer because of: \n\n\n\nOffer ID: ${productOffer.id}';
                          Helper().sendEmail('Report Product Offer [OVX Style App]', body, []);
                        },
												deleteFunction: () {
													context.read<AddOfferBloc>().add(
														DeleteOfferButtonPressed(
																productOffer.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
													);
												},
											),
										),
                  ],
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
                            '${productOffer.properties!.first.sizes!.first.price} ${SharedPref.getCurrency()}',
                            style: TextStyle(
                              fontSize: 18,
                              color: MyColors.secondaryColor,
                            ))
                        : Row(
                            children: [
                              Text(
                                '${productOffer.properties!.first.sizes!.first.price} ${SharedPref.getCurrency()}',
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${Helper().priceAfterDiscount(productOffer.properties!.first.sizes!.first.price!, productOffer.discount!)} ${SharedPref.getCurrency()}',
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
