

import 'package:ovx_style/model/package.dart';

class PackagesState {}

class PackagesInitialState extends PackagesState {}

class GetCurrentPackageLoading extends PackagesState {}

class GetCurrentPackageDone extends PackagesState {
}

class GetCurrentPackageFailed extends PackagesState {
  String message;

  GetCurrentPackageFailed(this.message);
}

class GetAllPackagesLoading extends PackagesState {}

class GetAllPackagesDone extends PackagesState {}

class GetAllPackagesFailed extends PackagesState {
  String message;

  GetAllPackagesFailed(this.message);
}

class SubscribeToPackageLoading extends PackagesState {}

class SubscribeToPackageDone extends PackagesState {}

class SubscribeToPackageFailed extends PackagesState {
  String message;

  SubscribeToPackageFailed(this.message);
}

class GetAvailableOffersLoading extends PackagesState {}

class GetAvailableOffersDone extends PackagesState {
  int availableOffers;

  GetAvailableOffersDone(this.availableOffers);
}

class GetAvailableOffersFailed extends PackagesState {
  String message;

  GetAvailableOffersFailed(this.message);
}

class GetChatAvailableDaysLoading extends PackagesState {}

class GetChatAvailableDaysDone extends PackagesState {}

class GetChatAvailableDaysFailed extends PackagesState {
  String message;

  GetChatAvailableDaysFailed(this.message);
}

// class GetStoryAvailableDaysLoading extends PackagesState {}
//
// class GetStoryAvailableDaysDone extends PackagesState {
//   int availableDays;
//
//   GetStoryAvailableDaysDone(this.availableDays);
// }
//
// class GetStoryAvailableDaysFailed extends PackagesState {
//   String message;
//
//   GetStoryAvailableDaysFailed(this.message);
// }