import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../widgets/country_picker.dart';
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
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_bloc.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_events.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_states.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/model/user.dart';

class EditProfileScreen extends StatelessWidget {
  final navigator;

  const EditProfileScreen({Key? key, this.navigator}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditUserBloc(),
      child: EditProfile(),
    );
  }
}


class EditProfile extends StatefulWidget {

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String newProfileImage = '';
  //only for company
  List<String> regImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit profile'.tr()),
      ),
      body: FutureBuilder(
        future: _databaseRepositoryImpl.getUserData(SharedPref.getUser().id!),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ),
            );
          else if (snapshot.hasError)
            return Center(
              child: Text('error occurred'.tr()),
            );
          else {
            late final user;
            if (snapshot.data is PersonUser)
              user = snapshot.data as PersonUser;
            else
              user = snapshot.data as CompanyUser;

            return BlocListener<EditUserBloc, EditUserState>(
              listener: (context, state) {
                if(state is EditUserLoading)
                  EasyLoading.show(status: 'please wait'.tr());
                else if(state is EditUserFailed)
                  EasyLoading.showError('error occurred'.tr());
                else if(state is EditUserSuccess)
                  EasyLoading.dismiss();
              },
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    ProfileImage(
                      defaultImage: user.profileImage,
                      saveImage: (imagePath) async {
                        newProfileImage = imagePath;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(
                      icon: 'person',
                      initialValue: user.userName,
                      hint: '',
                      validateInput: (userInput) {
                        if (userInput == "") return 'enter username'.tr();
                        return null;
                      },
                      saveInput: (userInput) {
                        user.userName = userInput;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            icon: 'person',
                            initialValue: user.nickName,
                            hint: '',
                            validateInput: (userInput) {
                              if (userInput == "") return 'enter nickname'.tr();
                              return null;
                            },
                            saveInput: (userInput) {
                              user.nickName = userInput;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 12,
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
                      height: 12,
                    ),
                    CustomTextFormField(
                      initialValue: user.email,
                      icon: 'email',
                      hint: '',
                      validateInput: (userInput) {
                        bool validEmail = AuthHelper.isEmailValid(userInput);
                        if (validEmail)
                          return null;
                        else
                          return 'enter email'.tr();
                      },
                      saveInput: (userInput) {
                        user.email = userInput;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    PhoneTextField(
                      validate: (_){},
                      save: (phoneNumber){
                        if(phoneNumber.length > 4)
                          user.phoneNumber = phoneNumber;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'current'.tr() + ': ${user.phoneNumber}',
                        style: Constants.TEXT_STYLE6.copyWith(
                          color: MyColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DescriptionTextField(
                      initialValue: user.shortDesc,
                      onSaved: (userInput) {
                        user.shortDesc = userInput;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (SharedPref.getUser().userType == UserType.Company.toString())
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'registration'.tr(),
                            style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RegistrationImagePicker(
                            save: (imagesPath){
                              regImages = imagesPath;
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          CustomTextFormField(
                            initialValue: user.regNumber,
                            hint: 'reg no'.tr(),
                            validateInput: (userInput) {
                              if (userInput == "") return 'enter reg no'.tr();
                              return null;
                            },
                            saveInput: (userInput) {
                              user.regNumber = userInput;
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    CountryPicker(
                      currentCity: user.city.isEmpty ? null : user.city,
                      currentCountry: user.country.isEmpty ? null : user.country ,
                      saveCountry: (val) {
                        user.country = val;
                      },
                      saveCity: (val) {
                        user.city = val;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        NamedNavigatorImpl().push(NamedRoutes.GOOGLE_MAPS_SCREEN, arguments: {
                          'onSave': (latitude, longitude) {
                            user.latitude = latitude;
                            user.longitude = longitude;
                          },
                        });
                      },
                      child: CustomRedirectWidget(
                        title: 'location on map'.tr(),
                        iconName: 'location_on_map',
                      ),
                    ),
                    SizedBox(height: 25),
                    CustomElevatedButton(
                        color: MyColors.secondaryColor,
                        text: 'Update'.tr(),
                        function: () {
                          bool valid = _formKey.currentState!.validate();
                          if(valid){
                            _formKey.currentState!.save();
                            context.read<EditUserBloc>().add(EditUserButtonPressed(user.toMap(), newProfileImage, regImages));
                          }

                          //context.read<EditUserBloc>().add(EditUserButtonPressed(user.toMap));
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}