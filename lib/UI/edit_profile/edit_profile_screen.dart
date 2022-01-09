import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/birthday_picker.dart';
import 'package:ovx_style/UI/auth/widgets/country_picker.dart';
import 'package:ovx_style/UI/auth/widgets/gender_picker.dart';
import 'package:ovx_style/UI/auth/widgets/password_text_field.dart';
import 'package:ovx_style/UI/auth/widgets/phone_text_field.dart';
import 'package:ovx_style/UI/auth/widgets/profile_image.dart';
import 'package:ovx_style/UI/auth/widgets/registration_image_picker.dart';
import 'package:ovx_style/UI/auth/widgets/terms_and_conditions.dart';
import 'package:ovx_style/UI/auth/widgets/user_code_text_field.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/description_text_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_events.dart';
import 'package:ovx_style/helper/auth_helper.dart';

class editProfile extends StatelessWidget {
  final navigator;

  const editProfile({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Edit Profile'),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          // imageSection(),
          ProfileImage(),
          Form(
            key: _signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  icon: 'person',
                  hint: 'full name'.tr(),
                  validateInput: (userInput) {
                    if (userInput == "") return 'enter username'.tr();
                    return null;
                  },
                  saveInput: (userInput) {
                    AuthHelper.userInfo['userName'] = userInput;
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        icon: 'person',
                        hint: 'nick name'.tr(),
                        validateInput: (userInput) {
                          if (userInput == "") return 'enter nickname'.tr();
                          return null;
                        },
                        saveInput: (userInput) {
                          AuthHelper.userInfo['nickName'] = userInput;
                        },
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.015,
                    ),
                    Expanded(
                      child: UserCodeTextField(),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                CustomTextFormField(
                  icon: 'email',
                  hint: 'email'.tr(),
                  validateInput: (userInput) {
                    bool validEmail = AuthHelper.isEmailValid(userInput);
                    if (validEmail)
                      return null;
                    else
                      return 'enter email'.tr();
                  },
                  saveInput: (userInput) {
                    AuthHelper.userInfo['email'] = userInput;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                PhoneTextField(),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GenderPicker(),
                    ),
                    SizedBox(
                      width: screenHeight * 0.015,
                    ),
                    Expanded(
                      child: BirthdayPicker(),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                if (AuthHelper.userInfo['userType'] ==
                    UserType.Person.toString())
                  SizedBox(height: screenHeight * 0.015),
                DescriptionTextField(
                  onSaved: (userInput) {
                    AuthHelper.userInfo['shortDesc'] = userInput;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                if (AuthHelper.userInfo['userType'] ==
                    UserType.Company.toString())
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'registration'.tr(),
                        style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      RegistrationImagePicker(),
                      SizedBox(height: screenHeight * 0.018),
                      CustomTextFormField(
                        hint: 'reg no'.tr(),
                        validateInput: (userInput) {
                          if (userInput == "") return 'enter reg no'.tr();
                          return null;
                        },
                        saveInput: (userInput) {
                          AuthHelper.userInfo['regNumber'] = userInput;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  ),
                Text(
                  'address info'.tr(),
                  style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                CountryPicker(),
                SizedBox(
                  height: screenHeight * 0.003,
                ),
                GestureDetector(
                  onTap: () {
                    NamedNavigatorImpl().push(NamedRoutes.GOOGLE_MAPS_SCREEN);
                  },
                  child: CustomRedirectWidget(
                    title: 'location on map'.tr(),
                    iconName: 'location_on_map',
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Text(
                  'Shipping Countries'.tr(),
                  style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                CustomTextFormField(
                  hint: 'Countries',
                  validateInput: (userInput) {
                    if (userInput == "") return 'enter Country'.tr();
                    return null;
                  },
                  saveInput: (userInput) {
                    AuthHelper.userInfo['regNumber'] = userInput;
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'Update'.tr(),
                    function: () {
                      // bool isSubmitted =
                      //     AuthHelper.submitSignUpForm(_signUpFormKey);
                      // if (isSubmitted)
                      //   bloc.add(SignUpButtonPressed(AuthHelper.userInfo));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
