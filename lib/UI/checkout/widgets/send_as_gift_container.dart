import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SendAsGiftContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){


        ModalSheets().showSendGift(context);

      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
          border: Border.all(
            color: MyColors.secondaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/gift.svg', fit: BoxFit.scaleDown),
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
      ),
    );
  }
}
