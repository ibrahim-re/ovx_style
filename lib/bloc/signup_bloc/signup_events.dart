
abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  Map<String, dynamic> userInfo;

  SignUpButtonPressed(this.userInfo);
}