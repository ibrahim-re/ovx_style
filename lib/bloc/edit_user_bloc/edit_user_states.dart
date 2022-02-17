
class EditUserState {}

class EditUserInitialized extends EditUserState {}

class EditUserLoading extends EditUserState {}

class EditUserSuccess extends EditUserState {}

class EditUserFailed extends EditUserState {
  String message;

  EditUserFailed(this.message);
}