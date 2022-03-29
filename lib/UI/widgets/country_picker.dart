import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class CountryPicker extends StatelessWidget {
  final saveCountry, saveCity;
  final currentCity, currentCountry;
  final bool showCities;

  CountryPicker({
    required this.saveCountry,
    required this.saveCity,
    this.currentCountry,
    this.currentCity,
    this.showCities = true,
  });
  @override
  Widget build(BuildContext context) {
    return CSCPicker(
      onCountryChanged: (val) {
        saveCountry(val);
      },
      onStateChanged: (val) {
        saveCity(val);
      },
      onCityChanged: (val) {
        //print(val);
      },
      currentState: currentCity,
      currentCountry: currentCountry,
      //flagState: showFlag ? CountryFlag.ENABLE : CountryFlag.DISABLE,
      showStates: showCities,
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
      stateDropdownLabel: '${'city'.tr()} *',
      countryDropdownLabel: '${'country'.tr()} *',
    );
  }
}
