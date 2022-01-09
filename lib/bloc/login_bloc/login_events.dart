
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  String email;
  String password;

  LoginButtonPressed(this.email, this.password);
}

class AppStarted extends LoginEvent{}