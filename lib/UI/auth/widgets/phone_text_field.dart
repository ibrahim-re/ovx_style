import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/country_picker.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class PhoneTextField extends StatefulWidget {
  final save;
  final validate;
  final controller;

  PhoneTextField({required this.save, this.controller, required this.validate});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String _phoneNumber = '+966';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: MyColors.secondaryColor,
      cursorWidth: 3,
      keyboardType: TextInputType.phone,
      style: Constants.TEXT_STYLE1,
      validator: widget.validate,
      onSaved: (userInput) {
        if (userInput != null) {
          widget.save(_phoneNumber + userInput);
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(
          Icons.phone_iphone,
          color: MyColors.grey,
          size: 27,
        ),
        suffixIcon: TextButton(
          child: Text(
            '$_phoneNumber',
            style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
          ),
          onPressed: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (country) {
                print('+${country.phoneCode}');
                setState(() {
                  _phoneNumber = '+${country.phoneCode}';
                });
              },
            );
          },
        ),
        hintText: 'mobile'.tr(),
        hintStyle: Constants.TEXT_STYLE1,
        errorStyle: TextStyle(
          fontWeight: FontWeight.w300,
          color: MyColors.red,
          fontSize: 12,
        ),
        enabledBorder: Constants.outlineBorder,
        focusedBorder: Constants.outlineBorder,
        errorBorder: Constants.outlineBorder,
        focusedErrorBorder: Constants.outlineBorder,
      ),
    );
  }
}
