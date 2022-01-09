import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class AuthOptionsScreen extends StatelessWidget {
  final navigator;

  const AuthOptionsScreen({this.navigator});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: screenHeight * 0.5,
                  child: Image.asset('assets/images/circles.png'),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                Center(
                  child: Text(
                    'be with us'.tr(),
                    style: Constants.TEXT_STYLE2,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Center(
                  child: Text(
                    'intro desc'.tr(),
                    textAlign: TextAlign.center,
                    style: Constants.TEXT_STYLE5,
                    ),
                  ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                CustomElevatedButton(
                  color: MyColors.secondaryColor,
                  text: 'company'.tr(),
                  function: () {
                    AuthHelper.userInfo['userType'] = UserType.Company.toString();
                    NamedNavigatorImpl().push(NamedRoutes.LOGIN_SCREEN);
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.012,
                ),
                CustomElevatedButton(
                  color: MyColors.lightBlue,
                  text: 'person'.tr(),
                  function: () {
                    AuthHelper.userInfo['userType'] = UserType.Person.toString();
                    NamedNavigatorImpl().push(NamedRoutes.LOGIN_SCREEN);
                  },
                ),
                TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    'login as a visitor'.tr(),
                    style: Constants.TEXT_STYLE4,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
