import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/date_picker_widget.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountDate extends StatefulWidget {
  @override
  _DiscountDateState createState() => _DiscountDateState();
}

class _DiscountDateState extends State<DiscountDate> {
  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String temp = await Helper().openDatePicker(context);

        setState(() {
          selectedDate = temp;
        });

        context.read<AddOfferBloc>().updateDiscountDate(selectedDate);
      },
      child: DatePickerWidget(selectedDate: selectedDate, hint: 'end date'.tr(),),
    );
  }
}


