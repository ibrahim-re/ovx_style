import 'package:localize_and_translate/localize_and_translate.dart';
import '../../api/users/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/reset_password_bloc/reset_password_events.dart';
import 'package:ovx_style/bloc/reset_password_bloc/reset_password_states.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState>{
  ResetPasswordBloc() : super(ResetPasswordInitial());

  AuthRepositoryImpl _authRepositoryImpl = AuthRepositoryImpl();

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if(event is RequestForResetPassword){
      try {
        yield ResetPasswordLoading();
        await _authRepositoryImpl.requestResetPasswordCode(event.email);
        yield ResetPasswordEmailSent();
      } catch (e) {
        String message = 'something wrong'.tr();
        switch(e){
          case 'user-disabled': message = 'user disabled'.tr(); break;
          case 'invalid-email': message = 'enter email'.tr(); break;
          case 'user-not-found': message = 'user not found'.tr(); break;
          case 'network-request-failed': message = 'network error'.tr(); break;
        }
        yield ResetPasswordFailed(message);
      }
    }
  }


}