import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:provider/src/provider.dart';

class UserSearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColors.secondaryColor,
      cursorWidth: 3,
      style: Constants.TEXT_STYLE1.copyWith(
        height: 1,
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (userInput) {
        if (userInput.isNotEmpty && userInput.length > 3)
          context.read<UserBloc>().add(SearchUser(userInput));
        else
          EasyLoading.showToast('5 chars at least'.tr());
      },
      onChanged: (userInput) {
        if (userInput.isNotEmpty && userInput.length > 3)
          context.read<UserBloc>().add(SearchUser(userInput));
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: Icon(
          Icons.search,
          color: MyColors.grey,
        ),
        hintText: 'user search'.tr(),
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
