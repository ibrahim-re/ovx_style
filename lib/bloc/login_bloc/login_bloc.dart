import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/notifications_helper.dart';
import '../../api/users/auth_repository.dart';
import 'package:ovx_style/bloc/login_bloc/login_events.dart';
import 'package:ovx_style/bloc/login_bloc/login_states.dart';
import 'package:ovx_style/model/user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  LoginBloc() : super(LoginInitial());

  AuthRepositoryImpl _authRepositoryImpl = AuthRepositoryImpl();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginButtonPressed){
      yield LoginLoading();
      try {
        User user = await _authRepositoryImpl.signInUser(event.email, event.password);
        if(user.id != null){
          SharedPref.setUser(user);
          //save device token to send notifications
          NotificationsHelper.saveDeviceTokenToDatabase();
          yield LoginSucceed();
        } else
          yield LoginFailed('login failed'.tr());
      } catch (e) {
        print('e is $e');
        String message = 'something wrong'.tr();
        switch(e){
          case 'user-disabled': message = 'user disabled'.tr(); break;
          case 'invalid-email': message = 'enter email'.tr(); break;
          case 'user-not-found': message = 'user not found'.tr(); break;
          case 'wrong-password': message = 'password wrong'.tr(); break;
          case 'network-request-failed': message = 'network error'.tr(); break;
        }
        yield LoginFailed(message);
      }
    }else if(event is AppStarted){
      try {
        User user = SharedPref.getUser();
        if(user.id != ''){
          String userSignedInId = await _authRepositoryImpl.checkSignInUser();
          if(userSignedInId.isNotEmpty && userSignedInId == user.id)
            yield LoginSucceed();
          else{
            SharedPref.deleteUser();
            yield LoginFailed('no user logged in'.tr());
          }
        }else{
          print('no user logged');
          yield LoginFailed('no user logged in'.tr());
        }
      } catch (e) {
        yield LoginFailed('no user logged in'.tr());
      }
    }else if(event is LoginAsGuest){
      yield LoginLoading();
      try {
        User user = await _authRepositoryImpl.signInAsGuest();
        if(user.id != null){
          SharedPref.setUser(user);
          yield LoginSucceed();
        } else
          yield LoginFailed('login failed'.tr());
      } catch (e) {
        print('e is $e');
        String message = 'something wrong'.tr();
        switch(e){
          case 'user-disabled': message = 'user disabled'.tr(); break;
          case 'invalid-email': message = 'enter email'.tr(); break;
          case 'user-not-found': message = 'user not found'.tr(); break;
          case 'wrong-password': message = 'password wrong'.tr(); break;
          case 'network-request-failed': message = 'network error'.tr(); break;
        }
        yield LoginFailed(message);
      }
    }
  }
}