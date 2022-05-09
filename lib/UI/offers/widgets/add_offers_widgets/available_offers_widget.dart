import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class AvailableOffersWidget extends StatelessWidget {
  final int availableOffers;

  AvailableOffersWidget({required this.availableOffers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: MyColors.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/info.svg'),
          const SizedBox(
            width: 8,
          ),
          Text(
            'you have'.tr() + ' ${availableOffers} ' + 'offers available'.tr(),
            style: Constants.TEXT_STYLE4,
          ),
        ],
      ),
    );
  }
}
