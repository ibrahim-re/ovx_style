import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    required this.selectedDate,
    required this.hint,
  });

  final hint;
  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: MyColors.lightGrey, width: 2),
      ),
      leading: SvgPicture.asset('assets/images/date.svg'),
      minLeadingWidth: 0,
      title: Text(
        selectedDate == '' ? hint : selectedDate,
        style: Constants.TEXT_STYLE1,
      ),
    );
  }
}