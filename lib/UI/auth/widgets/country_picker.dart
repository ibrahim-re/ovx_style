import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class CountryPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CSCPicker(
      onCountryChanged: (val) {
        AuthHelper.userInfo['country'] = val;
      },
      onStateChanged: (val) {
        AuthHelper.userInfo['city'] = val;
      },
      onCityChanged: (val) {
        //print(val);
      },

      currentCity: 'Syria',

      flagState: CountryFlag.DISABLE,
      showCities: false,
      selectedItemStyle: Constants.TEXT_STYLE1,
      dropdownItemStyle: Constants.TEXT_STYLE1,
      dropdownHeadingStyle: Constants.TEXT_STYLE1,

      dropdownDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: MyColors.primaryColor,
        border: Border.all(color: MyColors.lightGrey, width: 2),
      ),
      disabledDropdownDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: MyColors.lightGrey,
        border: Border.all(color: MyColors.lightGrey, width: 2),
      ),

      dropdownDialogRadius: 16,
      searchBarRadius: 16,

      stateDropdownLabel: 'City',
    );
  }
}
