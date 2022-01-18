import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/checkout/widgets/checkout_item.dart';
import 'package:ovx_style/UI/checkout/widgets/send_as_gift_container.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';

class checkOutScreen extends StatelessWidget {
  final navigator;
  checkOutScreen({
    Key? key,
    required this.navigator,
    required this.subtotal,
    required this.vat,
    required this.shippingCost,
  }) : super(key: key);

  final double subtotal, vat, shippingCost;

  @override
  Widget build(BuildContext context) {
    //calculate total
    final double total = subtotal+vat+shippingCost;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('checkout'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            checkoutItem(
              text: 'subtotal'.tr(),
              value: subtotal,
            ),
            VerticalSpaceWidget(heightPercentage: 0.03),
            checkoutItem(
              text: 'vat'.tr(),
              value: vat,
            ),
            VerticalSpaceWidget(heightPercentage: 0.03),
            checkoutItem(
              text: 'shipping costs'.tr(),
              value: shippingCost,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 30),
              child: Divider(
                color: MyColors.grey.withOpacity(0.2),
                thickness: 4,
              ),
            ),
            checkoutItem(
              text: 'total'.tr(),
              value: total,
            ),
            Spacer(),
            CustomElevatedButton(
              color: MyColors.secondaryColor,
              text: 'pay'.tr(),
              function: () {

              },
            ),
            VerticalSpaceWidget(heightPercentage: 0.03),
            SendAsGiftContainer(),
          ],
        ),
      ),
    );
  }
}
