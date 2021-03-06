import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/location_helper.dart';
import 'database_repository.dart';
import 'package:ovx_style/model/user.dart';

abstract class AuthRepository {
  Future<User> signUpUser(Map<String, dynamic> userInfo);
  Future<User> signInUser(String email, String password);
  Future<void> signOutUser();
  Future<User> signInAsGuest();
  Future<void> requestResetPasswordCode(String email);
  Future<String> checkSignInUser();
}

class AuthRepositoryImpl extends AuthRepository {
  firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Future<User> signInUser(String email, String password) async {
    try {
      firebase.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        String uId = userCredential.user!.uid;

        User user = await _databaseRepositoryImpl.getUserData(uId);

        return user;
      } else
        throw 'error';
    } on firebase.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> signUpUser(Map<String, dynamic> userInfo) async {
    try {
      String email = userInfo['email'];
      String password = userInfo['password'];
      firebase.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      //add user data to database
      if (userCredential.user != null) {
        //get user id
        String uId = userCredential.user!.uid;

        //upload user profile image to database
        if (userInfo['profileImage'] != null) {
          EasyLoading.show(status: 'Uploading profile image..');
          List<String> paths = [userInfo['profileImage']];
          List<String> downloadUrls = await _databaseRepositoryImpl
              .uploadFilesToStorage(paths, uId, 'profileImage');
          userInfo['profileImage'] = downloadUrls.first;
        }

        //upload company reg images to database
        if (userInfo['regImages'] != null) {
          EasyLoading.show(status: 'Uploading reg images..');
          List<String> downloadUrls = await _databaseRepositoryImpl
              .uploadFilesToStorage(userInfo['regImages'], uId, 'regImages');
          userInfo['regImages'] = downloadUrls;
        }

        userInfo['searchStrings'] = Helper().generateSearchStrings(userInfo['userName']);

        //initialize story and chat countries with user country
        userInfo['storyCountries'] = userInfo['country'];
        userInfo['chatCountries'] = userInfo['country'];
        userInfo['postsCountries'] = userInfo['country'];
        //do not store user password in firestore
        userInfo.remove('password');

        //set user id as path to his info
        await _databaseRepositoryImpl.addUserData(uId, userInfo);

        //check if user type is company or person
        if (userInfo['userType'] == UserType.Company.toString()) {
          User currentUser = CompanyUser.fromMap(userInfo, uId);
          return currentUser;
        } else {
          User currentUser = PersonUser.fromMap(userInfo, uId);

          return currentUser;
        }
      } else
        throw 'error';
    } on firebase.FirebaseAuthException catch (e) {
      print('error $e');
      throw e.code;
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  @override
  Future<void> requestResetPasswordCode(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<User> signInAsGuest() async {
    try {
      firebase.UserCredential userCredential = await _firebaseAuth.signInAnonymously();

      if (userCredential.user != null) {
        //get user id
        String uId = userCredential.user!.uid;

        //generate guest code and user name
        List<String> data = AuthHelper.generateGuestData();

        LocationData locationData = await LocationHelper().getUserLocation();
        Placemark address = await LocationHelper().getUserAddress(locationData.latitude!, locationData.longitude!);

        Map<String, dynamic> visitorUserINfo = {
          'email': "nomail@nomail.com",
          'gender': "Male",
          'nickName': "guest",
          'password': " ",
          'phoneNumber': " ",
          'country': address.country,
          'shortDesc': "",
          'userCode': data[1],
          'userName': data[0],
          'userType': UserType.Guest.toString(),
        };

        //set user id as path to his info
        await _databaseRepositoryImpl.addUserData(uId, visitorUserINfo);

        User currentUser = PersonUser.fromMap(visitorUserINfo, uId);

        return currentUser;
      } else
        throw ' error';
    } on firebase.FirebaseAuthException catch (e) {
      print('error $e');
      throw e.code;
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  @override
  Future<String> checkSignInUser() async {
    try{
      firebase.User? user = _firebaseAuth.currentUser;
      if(user?.uid != null)
        return user?.uid ?? '';
      else
        return '';
    }catch(e){
      print('error $e');
      throw e;
    }
  }
}
