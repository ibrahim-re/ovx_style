// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'colors.dart';

class Constants {
  static var outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: MyColors.lightGrey, width: 2),
  );

  static const TEXT_STYLE1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: MyColors.grey,
  );

  static const TEXT_STYLE2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: MyColors.secondaryColor,
  );

  static const TEXT_STYLE3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: MyColors.black,
  );

  static const TEXT_STYLE4 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: MyColors.black,
  );

  static const TEXT_STYLE5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: MyColors.black,
  );

  static const TEXT_STYLE6 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: MyColors.black,
  );

}
