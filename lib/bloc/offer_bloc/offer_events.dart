import 'package:ovx_style/Utiles/enums.dart';

abstract class OfferEvent {}

class FetchOffers extends OfferEvent {
  UserType offerOwnerType;

  FetchOffers(this.offerOwnerType);
}


class FilterOffers extends OfferEvent {
  double minPrice;
  double maxPrice;
  List<String> categories;

  FilterOffers(this.minPrice, this.maxPrice, this.categories);
}