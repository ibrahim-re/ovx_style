

import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/package.dart';

class PackagesEvent {}

class GetCurrentPackage extends PackagesEvent {}

class GetAllPackages extends PackagesEvent {}

class SubscribeToPackage extends PackagesEvent {
  Package package;

  SubscribeToPackage(this.package);
}


class GetAvailableOffersCount extends PackagesEvent {
  OfferType offerType;

  GetAvailableOffersCount(this.offerType);
}
//
class GetChatAvailableDays extends PackagesEvent {}
//
// class GetStoryAvailableDays extends PackagesEvent {}