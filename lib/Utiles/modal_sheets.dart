import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/UI/widgets/filters_widget.dart';
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
}