import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';


class DescriptionTextField extends StatelessWidget {
  final onSaved;
  final controller;
  final onChanged;
  final hint;

  DescriptionTextField({
    required this.onSaved,
    this.controller,
    this.onChanged,
    this.hint,
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: MyColors.secondaryColor,
      cursorWidth: 3,
      style: Constants.TEXT_STYLE1,
      maxLines: 3,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        hintText: hint == null || hint == '' ? 'short description'.tr() : hint,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: MyColors.grey,
        ),
        enabledBorder: Constants.outlineBorder,
        focusedBorder: Constants.outlineBorder,
        errorBorder: Constants.outlineBorder,
        focusedErrorBorder: Constants.outlineBorder,
      ),
    );
  }
}
