
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  String email;
  String password;

  LoginButtonPressed(this.email, this.password);
}

class LoginAsGuest extends LoginEvent {}

class AppStarted extends LoginEvent{}