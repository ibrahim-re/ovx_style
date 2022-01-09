import 'package:ovx_style/model/offer.dart';

abstract class OfferState {}

class OfferStateInitial extends OfferState {}

class FetchOffersLoading extends OfferState {}

class FetchOffersSucceed extends OfferState {
  List<Offer> fetchedOffers;

  FetchOffersSucceed(this.fetchedOffers);
}

class FetchOffersFailed extends OfferState {
  String message;

  FetchOffersFailed(this.message);
}