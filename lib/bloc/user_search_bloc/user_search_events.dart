
class UserSearchEvent {}

class SearchUser extends UserSearchEvent {
  String textToSearch;

  SearchUser(this.textToSearch);
}