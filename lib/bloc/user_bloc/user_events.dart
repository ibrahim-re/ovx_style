
import 'package:ovx_style/Utiles/enums.dart';

class UserEvent {}

class SearchUser extends UserEvent {
  String textToSearch;

  SearchUser(this.textToSearch);
}

class GetUserPrivacyPolicy extends UserEvent {
  String uId;

  GetUserPrivacyPolicy(this.uId);
}

class UpdateUserPrivacyPolicy extends UserEvent {
  String uId;
  String policy;

  UpdateUserPrivacyPolicy(this.uId, this.policy);
}

class ChangeCountries extends UserEvent {
  CountriesFor countriesFor;
  String changeTo;

  ChangeCountries(this.countriesFor, this.changeTo);
}

class ChangeUserLocation extends UserEvent {
  double latitude;
  double longitude;
  String country;

  ChangeUserLocation(this.latitude, this.longitude, this.country);
}

class GetReceiveGifts extends UserEvent {}

class ChangeReceiveGifts extends UserEvent {
  bool receiveGifts;

  ChangeReceiveGifts(this.receiveGifts);
}