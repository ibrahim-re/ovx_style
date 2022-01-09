
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordEmailSent extends ResetPasswordState {}

class ResetPasswordFailed extends ResetPasswordState {
  String message;

  ResetPasswordFailed(this.message);
}