import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/basket_helper.dart';

class ShipToSection extends StatefulWidget {
  const ShipToSection({Key? key, required this.shippingCosts})
      : super(key: key);

  final Map<String, double> shippingCosts;

  @override
  State<ShipToSection> createState() => _ShipToSectionState();
}

class _ShipToSectionState extends State<ShipToSection> {
  int currentIndex = 0;

  @override
  void dispose() {
    BasketHelper.tempShippingCost = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shippingCosts.isEmpty)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'no shipping'.tr(),
          style: Constants.TEXT_STYLE8,
        ),
      );
    else {

      //this is in case the user doesn't click on any country
      if(BasketHelper.tempShippingCost ==0){
        BasketHelper.tempShippingCost = widget.shippingCosts.values.first;
        BasketHelper.shipTo = widget.shippingCosts.keys.first;
      }


      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            Text(
              'ship to'.tr(),
              style: Constants.TEXT_STYLE8,
            ),
            const SizedBox(
              width: 8,
            ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              direction: Axis.horizontal,
              children: widget.shippingCosts.keys
                  .map(
                    (key) => GestureDetector(
                  onTap: () {
                    setState(() => currentIndex =
                        widget.shippingCosts.keys.toList().indexOf(key));

                    BasketHelper.tempShippingCost = widget.shippingCosts[key]!;
                    BasketHelper.shipTo = key; //key is the country name

                    print(BasketHelper.tempShippingCost);
                    EasyLoading.showInfo(
                        'Shipping cost for this country is ${widget.shippingCosts[key]} \$');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentIndex ==
                          widget.shippingCosts.keys.toList().indexOf(key)
                          ? MyColors.lightBlue
                          : MyColors.lightBlue.withOpacity(0.2),
                    ),
                    child: Text(key,
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      );
    }
  }
}
