import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/offer_type_widget.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
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

  void showTermsAndConditions(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  'terms and conds'.tr(),
                  style: Constants.TEXT_STYLE1,
                ),
              ),
            ),
          );
        });
  }

  void showSendGift(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        borderSide: BorderSide(color: MyColors.primaryColor),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/images/gift.svg',
                      fit: BoxFit.scaleDown),
                  const SizedBox(width: 6),
                  Text(
                    'send gift'.tr(),
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
                  'enter friend code'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
              CustomTextFormField(
                hint: 'friend code'.tr(),
                validateInput: (p) {},
                saveInput: (p) {},
              ),
              const SizedBox(height: 8,),
              CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'send'.tr(),
                function: () {},
              ),
              //to left the screen up as much as the bottom keyboard takes, so we can scroll down
              Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        );
      },
    );
  }
}
