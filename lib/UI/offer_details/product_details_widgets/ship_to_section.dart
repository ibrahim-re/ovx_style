import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

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
  Widget build(BuildContext context) {
    if (widget.shippingCosts.isEmpty)
      return Text(
        'no shipping'.tr(),
        style: Constants.TEXT_STYLE8,
      );
    else
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
                    (k) => GestureDetector(
                      onTap: () {
                        setState(() => currentIndex =
                            widget.shippingCosts.keys.toList().indexOf(k));
                        EasyLoading.showInfo(
                            'Shipping cost for this country is ${widget.shippingCosts[k]} \$');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex ==
                                  widget.shippingCosts.keys.toList().indexOf(k)
                              ? MyColors.lightBlue
                              : MyColors.lightBlue.withOpacity(0.2),
                        ),
                        child: Text(k,
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
