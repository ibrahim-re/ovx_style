import 'package:ovx_style/Utiles/enums.dart';

abstract class OfferEvent {}

class FetchOffers extends OfferEvent {
  UserType offerOwnerType;

  FetchOffers(this.offerOwnerType);
}

class FetchMoreOffers extends OfferEvent {
  UserType offerOwnerType;
  String lastFetchedOfferId;

  FetchMoreOffers(this.offerOwnerType, this.lastFetchedOfferId);
}

class GetUserOffers extends OfferEvent {
  String uId;
  String offerOwnerType;

  GetUserOffers(this.uId, this.offerOwnerType);
}

class GetMyLikedOffers extends OfferEvent {
  String uId;

  GetMyLikedOffers(this.uId);
}

class GetFilteredOffers extends OfferEvent {
  double minPrice;
  double maxPrice;
  List<String> categories;
  String status;
  List<String> offerTypes;
  UserType userType;

  GetFilteredOffers(this.minPrice, this.maxPrice, this.categories, this.status, this.offerTypes, this.userType);
}