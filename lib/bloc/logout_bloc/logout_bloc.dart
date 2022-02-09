
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/notifications_helper.dart';
import '../../api/users/auth_repository.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_events.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_states.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState>{
  LogoutBloc() : super(LogoutInitial());

  AuthRepositoryImpl _authRepositoryImpl = AuthRepositoryImpl();

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if(event is LogoutButtonPressed){
      yield LogoutLoading();
      try {
        //delete device token when user sign out
        //NotificationsHelper.deleteDeviceTokenFromDatabase();
        await _authRepositoryImpl.signOutUser();
        await SharedPref.deleteUser();
        print('user signed out');
        yield LogoutSucceed();
      } catch (e) {
        print('user not signed out');
        String message = 'something wrong'.tr();
        switch(e){
          case 'network-request-failed': message = 'network error'.tr(); break;
        }
        yield LogoutFailed(message);
      }
    }

  }
}