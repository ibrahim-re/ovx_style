
abstract class ResetPasswordEvent {}

class RequestForResetPassword extends ResetPasswordEvent {
  String email;

  RequestForResetPassword(this.email);
}