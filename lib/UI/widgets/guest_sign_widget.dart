import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';


class GuestSignWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ModalSheets().showSignSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 22),
        color: MyColors.lightBlue.withOpacity(0.2),
        child: Text(
          'go'.tr(),
          style: Constants.TEXT_STYLE9,
        ),
      ),
    );
  }
}
