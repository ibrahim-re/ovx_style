import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';


class PhoneTextField extends StatefulWidget {

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColors.secondaryColor,
      cursorWidth: 3,
      style: Constants.TEXT_STYLE1,
      validator: (userInput){
        if(userInput!.isEmpty) return 'enter phone'.tr();

        return null;
      },
      onSaved: (userInput){
        if(userInput != null)
          AuthHelper.userInfo['phoneNumber'] = _phoneNumber+userInput;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(
          Icons.phone_iphone,
          color: MyColors.grey,
          size: 27,
        ),
        suffixIcon: CountryCodePicker(
          showFlag: false,
          searchStyle: Constants.TEXT_STYLE1.copyWith(fontWeight: FontWeight.w500),
          dialogTextStyle: Constants.TEXT_STYLE1.copyWith(fontWeight: FontWeight.w500),
          textStyle: Constants.TEXT_STYLE1.copyWith(fontWeight: FontWeight.w500),
          initialSelection: 'SA',
          onChanged: (code){
            setState(() {
              _phoneNumber = code.toString();
            });
            print(_phoneNumber);
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
