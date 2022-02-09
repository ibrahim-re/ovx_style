import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/birthday_picker.dart';
import 'package:ovx_style/UI/auth/widgets/country_picker.dart';
import 'package:ovx_style/UI/auth/widgets/gender_picker.dart';
import 'package:ovx_style/UI/auth/widgets/phone_text_field.dart';
import 'package:ovx_style/UI/auth/widgets/profile_image.dart';
import 'package:ovx_style/UI/auth/widgets/registration_image_picker.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/description_text_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/model/user.dart';

class EditProfileScreen extends StatefulWidget {
  final navigator;

  const EditProfileScreen({Key? key, this.navigator}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  late var user;

  TextEditingController userNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController regNumberController = TextEditingController();

  @override
  void initState() {
    String userType = SharedPref.getUser().userType!;
    if(userType == UserType.Person.toString())
      user = SharedPref.getUser() as PersonUser;
    else{
      user = SharedPref.getUser() as CompanyUser;
      regNumberController.text = user.regNumber;
    }

    userNameController.text = user.userName!;
    nickNameController.text = user.nickName!;
    emailController.text = user.email!;
    descController.text = user.shortDesc!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('edit profile'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // imageSection(),
          ProfileImage(),
          Form(
            key: _signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: userNameController,
                  icon: 'person',
                  hint: '',
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
                        controller: nickNameController,
                        icon: 'person',
                        hint: '',
                        validateInput: (userInput) {},
                        saveInput: (userInput) {

                          if(userInput != '')
                            print('nick name is $userInput');

                        },
                      ),
                    ),
                    SizedBox(
                      width: screenHeight * 0.015,
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        icon: 'person',
                        hint: user.userCode,
                        enabled: false,
                        validateInput: (userInput) {},
                        saveInput: (userInput) {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                CustomTextFormField(
                  controller: emailController,
                  icon: 'email',
                  hint: '',
                  validateInput: (userInput) {},
                  saveInput: (userInput) {

                    if(userInput != '')
                      print('email is $userInput');

                  },
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                PhoneTextField(),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                DescriptionTextField(
                  controller: descController,
                  hint: '',
                  onSaved: (userInput) {
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                if (SharedPref.getUser().userType == UserType.Company.toString())
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
                        hint: '',
                        validateInput: (userInput) {
                        },
                        saveInput: (userInput) {
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
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'Update'.tr(),
                    function: () {

                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
