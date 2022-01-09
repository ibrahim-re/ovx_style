
abstract class SignUpState {}

class SignUpInitial extends SignUpState {

}

class SignUpLoading extends SignUpState {

}

class SignUpSucceed extends SignUpState {

}

class SignUpFailed extends SignUpState {
  String message;

  SignUpFailed(this.message);
}