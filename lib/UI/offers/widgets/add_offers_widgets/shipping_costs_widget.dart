import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'countries_shipping_listview.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class ShippingCostsWidget extends StatefulWidget {
  @override
  _ShippingCostsWidgetState createState() => _ShippingCostsWidgetState();
}

class _ShippingCostsWidgetState extends State<ShippingCostsWidget> {

  @override
  void dispose() {
    OfferHelper.shippingCosts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'shipping costs'.tr(),
              style: Constants.TEXT_STYLE4,
            ),
            TextButton.icon(
              onPressed: () async {
                //wait for adding sizes to end and update th ui to show them
                await NamedNavigatorImpl().push(NamedRoutes.ADD_SHIPPING_COST_SCREEN);
                setState(() {});
              },
              icon: Icon(
                Icons.add,
                color: MyColors.secondaryColor,
              ),
              label: Text(
                'add'.tr(),
                style: Constants.TEXT_STYLE4.copyWith(
                  color: MyColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
        CountriesShippingListView(),
      ],
    );
  }
}
