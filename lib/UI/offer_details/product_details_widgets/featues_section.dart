import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class featuresSection extends StatelessWidget {
  const featuresSection(
      {Key? key, required this.isReturnAvailable, required this.isShippingFree})
      : super(key: key);

  final bool isReturnAvailable;
  final bool isShippingFree;

  @override
  Widget build(BuildContext context) {
    if (isReturnAvailable == false && isShippingFree == false)
      return Container();
    else
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'features'.tr(),
              style: Constants.TEXT_STYLE8,
            ),
            const SizedBox(height: 16),
            isReturnAvailable == false
                ? Container()
                : Row(
                    children: [
                      SvgPicture.asset('assets/images/return.svg'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('return products'.tr()),
                      ),
                      Spacer(),
                      Icon(Icons.done, color: MyColors.lightBlue),
                    ],
                  ),
            const SizedBox(height: 16),
            isShippingFree == false
                ? Container()
                : Row(
                    children: [
                      SvgPicture.asset('assets/images/free.svg'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('free shipping'.tr()),
                      ),
                      Spacer(),
                      Icon(Icons.done, color: MyColors.lightBlue),
                    ],
                  ),
          ],
        ),
      );
  }
}
