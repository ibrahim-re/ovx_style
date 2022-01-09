import 'package:flutter/material.dart';
import 'package:ovx_style/UI/auth/widgets/login_form.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class LoginScreen extends StatelessWidget {
  final navigator;

  const LoginScreen({this.navigator});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 35, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/images/logo2.png'),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Text(
                'welcome'.tr(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  color: MyColors.secondaryColor,
                ),
              ),
              Text(
                'login desc'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              LoginForm(),
              SizedBox(
                height: screenHeight * 0.025,
              ),
              Row(
                children: [
                  Text(
                    'no account'.tr(),
                    style: Constants.TEXT_STYLE4,
                  ),
                  GestureDetector(
                    onTap: () {
                        NamedNavigatorImpl().push(NamedRoutes.SIGNUP_SCREEN, replace: true);
                    },
                    child: Text(
                      'sign up'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  NamedNavigatorImpl().push(NamedRoutes.RESET_PASSWORD_SCREEN);
                },
                child: Text(
                  'forget password'.tr(),
                  style: Constants.TEXT_STYLE4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
