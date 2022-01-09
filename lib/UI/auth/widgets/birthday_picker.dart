import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/date_picker_widget.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/helper/helper.dart';

class BirthdayPicker extends StatefulWidget {
  @override
  _BirthdayPickerState createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String temp = await Helper().openDatePicker(context);

        setState((){
          selectedDate = temp;
        });
        AuthHelper.userInfo['dateBirth'] = selectedDate;
      },
      child: DatePickerWidget(selectedDate: selectedDate, hint: 'date birth'.tr(),),
    );
  }
}


