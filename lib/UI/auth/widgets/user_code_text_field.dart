import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class UserCodeTextField extends StatefulWidget {
  @override
  _UserCodeTextFieldState createState() => _UserCodeTextFieldState();
}

class _UserCodeTextFieldState extends State<UserCodeTextField> {
  String userCode = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        final newCode = AuthHelper.generateUserCode();
        setState(() {
          userCode = newCode;
        });
        AuthHelper.userInfo['userCode'] = newCode;
      },
      child: CustomTextFormField(
        icon: 'person',
        hint: userCode.isEmpty? 'user code'.tr() : userCode,
        enabled: false,
        validateInput: (_){
          if(userCode == "")
            return 'user code required'.tr();
          return null;
        },
        saveInput: (_){
          //print(userCode);
        },
      ),
    );
  }
}
