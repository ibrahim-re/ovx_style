import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';

class PasswordTextField extends StatefulWidget {
  final controller;
  final validateInput;
  final saveInput;

  PasswordTextField({
    this.controller,
    @required this.validateInput,
    @required this.saveInput,
});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hint: 'password'.tr(),
      icon: 'lock',
      keyboardType: TextInputType.visiblePassword,
      isPassword: true,
      showPassword: _showPassword,
      showPasswordFunction: () {
        setState(() {
          _showPassword = !_showPassword;
        });
      },
      validateInput: widget.validateInput,
      saveInput: widget.saveInput,
    );
  }
}
