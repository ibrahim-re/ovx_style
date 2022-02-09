import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/notifications_helper.dart';
import '../../api/users/auth_repository.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_events.dart';
import 'package:ovx_style/bloc/signup_bloc/signup_states.dart';
import 'package:ovx_style/model/user.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>{
  SignUpBloc() : super(SignUpInitial());

  AuthRepositoryImpl _authRepositoryImpl = AuthRepositoryImpl();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if(event is SignUpButtonPressed){
      yield SignUpLoading();
      try {
        User user = await _authRepositoryImpl.signUpUser(event.userInfo);
        if(user.id != null){
          SharedPref.setUser(user);
          //save device token to send notifications
          NotificationsHelper.saveDeviceTokenToDatabase();
          yield SignUpSucceed();
        }
        else
          yield SignUpFailed('Sign up failed');
      }catch (e) {
        print('rrrrrrrrrrrrrrrrrrrrrr');
        String message = 'something wrong'.tr();
        switch(e){
          case 'email-already-in-use': message = 'email in use'.tr(); break;
          case 'invalid-email': message = 'enter email'.tr(); break;
          case 'weak-password': message = 'password weak'.tr(); break;
          case 'network-request-failed': message = 'network error'.tr(); break;
        }
        yield SignUpFailed(message);
      }
    }
  }

}