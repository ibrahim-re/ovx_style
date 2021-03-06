import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/gender_picker.dart';
import 'package:ovx_style/UI/auth/widgets/password_text_field.dart';
import 'package:ovx_style/UI/auth/widgets/phone_text_field.dart';
import 'package:ovx_style/UI/auth/widgets/registration_image_picker.dart';
import 'package:ovx_style/UI/auth/widgets/terms_and_conditions.dart';
import 'package:ovx_style/UI/auth/widgets/birthday_picker.dart';
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
import 'package:ovx_style/bloc/signup_bloc/signup_bloc.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_events.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_states.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/helper/helper.dart';
import '../../widgets/country_picker.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    passController.dispose();
    AuthHelper.userInfo.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if (state is SignUpSucceed) {
          EasyLoading.dismiss();
          NamedNavigatorImpl().push(NamedRoutes.HOME_SCREEN, clean: true);
        } else if (state is SignUpFailed) {
          EasyLoading.dismiss();
          EasyLoading.showError(state.message);
        }
      },
      child: Form(
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
            SizedBox(
              height: screenHeight * 0.015,
            ),
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
              keyboardType: TextInputType.emailAddress,
              validateInput: (userInput) {
                bool validEmail = AuthHelper.isEmailValid(userInput.trim());
                if (validEmail)
                  return null;
                else
                  return 'enter email'.tr();
              },
              saveInput: (userInput) {
                AuthHelper.userInfo['email'] = userInput.toString().trim().toLowerCase();
              },
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            PhoneTextField(
              validate: (userInput){
                if(userInput!.isEmpty) return 'enter phone'.tr();

                return null;
              },
              save: (phoneNumber){
                AuthHelper.userInfo['phoneNumber'] = phoneNumber;
              },
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            if (AuthHelper.userInfo['userType'] == UserType.User.toString())
              Row(
                children: [
                  Expanded(
                    child: GenderPicker(
                      onSaved: (val){
                        AuthHelper.userInfo['gender'] = val;
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenHeight * 0.015,
                  ),
                  Expanded(
                    child: BirthdayPicker(
                      save: (selectedDate){
                        AuthHelper.userInfo['dateBirth'] = selectedDate;
                      },
                    ),
                  ),
                ],
              ),
            if (AuthHelper.userInfo['userType'] == UserType.User.toString())
              SizedBox(
                height: screenHeight * 0.015,
              ),
            DescriptionTextField(
              onSaved: (userInput) {
                AuthHelper.userInfo['shortDesc'] = userInput;
              },
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            if (AuthHelper.userInfo['userType'] == UserType.Company.toString())
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
                  RegistrationImagePicker(
                    save: (imagesPath){
                      AuthHelper.userInfo['regImages'] = imagesPath;
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.018,
                  ),
                  CustomTextFormField(
                    hint: 'reg no'.tr(),
                    keyboardType: TextInputType.number,
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
            CountryPicker(
              saveCountry: (val) {
                AuthHelper.userInfo['countryFlag'] = Helper().getCountryFlag(val);
              },
              saveCity: (val) {
                AuthHelper.userInfo['city'] = val;
              },
            ),
            SizedBox(
              height: screenHeight * 0.003,
            ),
            GestureDetector(
              onTap: () {
                NamedNavigatorImpl().push(NamedRoutes.GOOGLE_MAPS_SCREEN, arguments: {
                  'onSave': (latitude, longitude, country) {
                    AuthHelper.userInfo['latitude'] = latitude;
                    AuthHelper.userInfo['longitude'] = longitude;
                    AuthHelper.userInfo['country'] = country;
                  },
                });
              },
              child: CustomRedirectWidget(
                title: 'location on map'.tr(),
                iconName: 'location_on_map',
              ),
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            PasswordTextField(
              controller: passController,
              validateInput: (userInput) {
                if (userInput == "")
                  return 'enter password'.tr();
                else if (userInput.toString().length < 6)
                  return 'password short'.tr();
                return null;
              },
              saveInput: (userInput) {
                AuthHelper.userInfo['password'] = userInput;
              },
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            PasswordTextField(
              validateInput: (userInput) {
                if (userInput == "")
                  return 'enter password'.tr();
                else if (userInput.toString().length < 6)
                  return 'password short'.tr();
                else if (userInput != passController.text)
                  return 'no match pass'.tr();
                return null;
              },
              saveInput: (userInput) {
                //print(userInput);
              },
            ),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            TermsAndConditions(),
            SizedBox(
              height: screenHeight * 0.025,
            ),
            CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'signup'.tr(),
                function: () {
                  //if it's a company, reg info is required
                  if(AuthHelper.userInfo['userType'] == UserType.Company.toString()
                  && AuthHelper.userInfo['regImages'] == null){
                    EasyLoading.showError('reg images required'.tr());
                    return null;
                  }
                  bool isSubmitted = AuthHelper.submitSignUpForm(_signUpFormKey);
                  if (isSubmitted)
                    bloc.add(SignUpButtonPressed(AuthHelper.userInfo));
                }),
          ],
        ),
      ),
    );
  }
}
