import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/profile_image.dart';
import 'package:ovx_style/UI/auth/widgets/signup_form.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_bloc.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class SignupScreen extends StatelessWidget {
  final navigator;

  const SignupScreen({this.navigator});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 35, right: 20, left: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/logo2.png'),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  Text(
                    'be with us'.tr(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: MyColors.secondaryColor,
                    ),
                  ),
                  Text(
                    'signup desc'.tr(),
                    style: Constants.TEXT_STYLE4,
                  ),
                  ProfileImage(
                    saveImage: (imagePath){
                      AuthHelper.userInfo['profileImage'] = imagePath;
                    },
                  ),
                  SignupForm(),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  Row(
                    children: [
                      Text(
                        'already has account'.tr(),
                        style: Constants.TEXT_STYLE4,
                      ),
                      GestureDetector(
                        onTap: () {
                          NamedNavigatorImpl().push(NamedRoutes.LOGIN_SCREEN, replace: true);
                        },
                        child: Text(
                          'log in'.tr(),
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
                    height: screenHeight * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
