import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:min_id/min_id.dart';
import 'package:ovx_style/model/user.dart';

class AuthHelper {
  //user temporary info required for sign up
  static Map<String, dynamic> userInfo = {};
  //to check if user agreed on terms and conditions
  static bool agreedOnTerms = false;

  //check if email is valid
  static bool isEmailValid(String email) {
    if (email == "" || email.isEmpty) {
      return false;
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return false;
    }
    return true;
  }

  //to submit forms
  static bool submitLoginForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()){
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  static bool submitSignUpForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()){
      if(AuthHelper.userInfo['country'] == null ||
          AuthHelper.userInfo['countryFlag'] == null ||
          AuthHelper.userInfo['country'] == '' ||
          AuthHelper.userInfo['latitude'] == null ||
          AuthHelper.userInfo['latitude'] == 0 ||
          AuthHelper.userInfo['longitude'] == 0 ||
          AuthHelper.userInfo['longitude'] == null){
        EasyLoading.showInfo('please enter address'.tr());
        return false;
      }

      if(agreedOnTerms){
        formKey.currentState!.save();
        return true;
      }
      else {
        EasyLoading.showInfo('you should agree on terms and conditions'.tr());
        return false;
      }
    }
    return false;
  }

  //generate user code automatically
  static String generateUserCode() {
    String userCode = '';
    AuthHelper.userInfo['userType'] == UserType.User.toString()
        ? userCode = MinId.getId('user{6{d}}')
        : userCode = MinId.getId('com{6{d}}');

    return userCode;
  }

  //generate guest code and user name
  static List<String> generateGuestData() {
    String guestCode = '';
    String guestUserName = '';

    String code = MinId.getId('{6{d}}');

    guestCode = 'user$code';
    guestUserName = 'Guest$code';

    return [guestUserName, guestCode];
  }

  static Future<User> getUser(String userId) async {
    DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
    User user = await databaseRepositoryImpl.getUserById(userId);
    return user;
  }
}
