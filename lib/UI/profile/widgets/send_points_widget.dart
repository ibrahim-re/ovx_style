import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class SendPointsWidget extends StatefulWidget {
  @override
  State<SendPointsWidget> createState() => _SendPointsWidgetState();
}

class _SendPointsWidgetState extends State<SendPointsWidget> {
  TextEditingController amountController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        if(SharedPref.getUser().userType == UserType.Guest.toString())
          ModalSheets().showSignSheet(context);
        else
          ModalSheets().showSendPoints(context, amountController, codeController);
      },
      icon: SvgPicture.asset('assets/images/send_points.svg', fit: BoxFit.scaleDown,),
    );
  }
}
