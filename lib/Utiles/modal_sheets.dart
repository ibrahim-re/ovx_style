import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/UI/widgets/filters_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'constants.dart';
import 'enums.dart';

class ModalSheets {
  void showOfferTypePicker(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'offer type'.tr(),
              style: Constants.TEXT_STYLE2.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OfferTypeWidget(
                  iconName: 'product',
                  title: 'product'.tr(),
                  offerType: OfferType.Product,
                ),
                OfferTypeWidget(
                  iconName: 'video',
                  title: 'video'.tr(),
                  offerType: OfferType.Video,
                ),
                OfferTypeWidget(
                  iconName: 'image',
                  title: 'image'.tr(),
                  offerType: OfferType.Image,
                ),
                OfferTypeWidget(
                  iconName: 'post',
                  title: 'post'.tr(),
                  offerType: OfferType.Post,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showFilters(context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) => FiltersWidget(),
    );
  }

  void showSendGift(context) {
    showModalBottomSheet(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.wallet_giftcard_outlined,
                    color: MyColors.secondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Send as A Gift'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: MyColors.secondaryColor,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Kindly, Enter Your Friend Code'.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Friend Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: MyColors.grey,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  NamedNavigatorImpl().push(
                    NamedRoutes.Payment,
                    replace: true,
                    clean: true,
                  );
                },
                child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyColors.secondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: MyColors.secondaryColor,
                    ),
                    child: Text(
                      'Send'.toUpperCase().tr(),
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColors.primaryColor,
                      ),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
