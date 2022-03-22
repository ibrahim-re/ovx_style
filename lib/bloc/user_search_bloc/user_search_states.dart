
import 'package:ovx_style/model/user.dart';

class UserSearchState {}

class UserSearchInitial extends UserSearchState {}

class UserSearchLoading extends UserSearchState {}

class UserSearchDone extends UserSearchState {
  List<User> users;

  UserSearchDone(this.users);
}

class UserSearchFailed extends UserSearchState {
  String message;

  UserSearchFailed(this.message);
}