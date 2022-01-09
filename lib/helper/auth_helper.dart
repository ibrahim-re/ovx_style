import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      if(agreedOnTerms){
        formKey.currentState!.save();
        return true;
      }
      else {
        EasyLoading.showInfo('You should agree on terms and conditions');
        return false;
      }
    }
    return false;
  }

  //generate user code automatically
  static String generateUserCode() {
    String id = '';
    AuthHelper.userInfo['userType'] == UserType.Person.toString()
        ? id = MinId.getId('user{6{d}}')
        : id = MinId.getId('com{6{d}}');

    return id;
  }

  static Future<User> getUser(String offerOwnerId) async {
    DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
    User user = await databaseRepositoryImpl.getUserById(offerOwnerId);
    return user;
  }
}
