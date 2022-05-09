
import 'package:ovx_style/model/user.dart';

class UserState {}

class UserSearchInitial extends UserState {}

class UserSearchLoading extends UserState {}

class UserSearchDone extends UserState {
  List<User> users;

  UserSearchDone(this.users);
}

class UserSearchFailed extends UserState {
  String message;

  UserSearchFailed(this.message);
}

class GetUserPrivacyPolicyLoading extends UserState {}

class GetUserPrivacyPolicyDone extends UserState {
}

class GetUserPrivacyPolicyFailed extends UserState {
  String message;

  GetUserPrivacyPolicyFailed(this.message);
}

class UpdateUserPrivacyPolicyLoading extends UserState {}

class UpdateUserPrivacyPolicyDone extends UserState {}

class UpdateUserPrivacyPolicyFailed extends UserState {
  String message;

  UpdateUserPrivacyPolicyFailed(this.message);
}

class ChangeCountriesLoading extends UserState {}

class ChangeCountriesDone extends UserState {
  String changeTo;

  ChangeCountriesDone(this.changeTo);
}

class ChangeCountriesFailed extends UserState {
  String message;

  ChangeCountriesFailed(this.message);
}

class ChangeUserLocationLoading extends UserState {}

class ChangeUserLocationDone extends UserState {}

class ChangeUserLocationFailed extends UserState {
  String message;

  ChangeUserLocationFailed(this.message);
}

class GetReceiveGiftsLoading extends UserState {}

class GetReceiveGiftsDone extends UserState {
  bool receiveGifts;

  GetReceiveGiftsDone(this.receiveGifts);
}

class GetReceiveGiftsFailed extends UserState {}

class ChangeReceiveGiftsLoading extends UserState {}

class ChangeReceiveGiftsDone extends UserState {
  bool receiveGifts;

  ChangeReceiveGiftsDone(this.receiveGifts);
}

class ChangeReceiveGiftsFailed extends UserState {
  String message;

  ChangeReceiveGiftsFailed(this.message);
}