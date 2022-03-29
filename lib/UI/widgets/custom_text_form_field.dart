import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final controller;
  final hint;
  final icon;
  final keyboardType;
  final showPassword;
  final isPassword;
  final showPasswordFunction;
  final validateInput;
  final saveInput;
  final enabled;
  final onChanged;
  final initialValue;
  final height;

  CustomTextFormField({
    this.controller,
    @required this.hint,
    this.icon,
    this.keyboardType,
    this.showPassword = true,
    this.isPassword = false,
    this.showPasswordFunction,
    this.enabled = true,
    this.onChanged,
    this.initialValue,
    this.height,
    @required this.validateInput,
    @required this.saveInput,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      cursorColor: MyColors.secondaryColor,
      cursorWidth: 3,
      style: height != null ? Constants.TEXT_STYLE1.copyWith(height: 1) : Constants.TEXT_STYLE1,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: showPassword ? false : true,
      validator: validateInput,
      onSaved: saveInput,
      onChanged: onChanged,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: icon != null
            ? const EdgeInsets.symmetric(vertical: 16)
            : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: icon != null
            ? SvgPicture.asset(
                'assets/images/$icon.svg',
                fit: BoxFit.scaleDown,
              )
            : null,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: showPasswordFunction,
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: MyColors.grey,
                ),
              )
            : null,
        hintText: hint,
        errorStyle: TextStyle(
          fontWeight: FontWeight.w300,
          color: MyColors.red,
          fontSize: 12,
        ),
        hintStyle: Constants.TEXT_STYLE1,
        enabledBorder: Constants.outlineBorder,
        disabledBorder: Constants.outlineBorder,
        focusedBorder: Constants.outlineBorder,
        errorBorder: Constants.outlineBorder,
        focusedErrorBorder: Constants.outlineBorder,
      ),
    );
  }
}
