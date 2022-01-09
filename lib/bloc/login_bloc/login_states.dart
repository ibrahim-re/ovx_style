
abstract class LoginState {}

class LoginInitial extends LoginState{}

class LoginLoading extends LoginState{}

class LoginSucceed extends LoginState{
}

class LoginFailed extends LoginState{
  String message;

  LoginFailed(this.message);
}