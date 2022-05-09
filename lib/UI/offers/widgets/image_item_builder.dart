// offer type= image
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
          GestureDetector(
            onTap: (){
              NamedNavigatorImpl().push(
                NamedRoutes.Post_Image_Details,
                arguments: {'offer': imageOffer},
              );
            },
            child: Container(
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
                      imageError: 'assets/images/no_internet.png',
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
          ),
          BlocListener<AddOfferBloc, AddOfferState>(
            listener: (ctx, state) {
              if (state is DeleteOfferLoading)
                EasyLoading.show(status: 'please wait'.tr());
              else if(state is DeleteOfferSucceed){
                EasyLoading.showSuccess('offer deleted'.tr());
                NamedNavigatorImpl().pop();
              }
              else if (state is DeleteOfferFailed)
                EasyLoading.showError(state.message);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomPopUpMenu(
                reportFunction: (){
                  String body = 'I want to report this image offer because of: \n\n\n\nOffer ID: ${imageOffer.id}';
                  Helper().sendEmail('Report Image Offer [OVX Style App]', body, []);
                },
                shareFunction: () async {
                  OfferHelper.shareImage(imageOffer.offerMedia);
                },
                ownerId: imageOffer.offerOwnerId,
                deleteFunction: () {
                  context.read<AddOfferBloc>().add(
                    DeleteOfferButtonPressed(
                        imageOffer.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}