
abstract class LogoutState {}

class LogoutInitial extends LogoutState{}

class LogoutLoading extends LogoutState{}

class LogoutSucceed extends LogoutState{}

class LogoutFailed extends LogoutState{
  String message;

  LogoutFailed(this.message);
}

