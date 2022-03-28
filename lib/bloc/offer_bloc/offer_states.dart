import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/model/offer.dart';

abstract class OfferState {}

class OfferStateInitial extends OfferState {}

class FetchOffersLoading extends OfferState {}

class FetchOffersSucceed extends OfferState {}

class FetchOffersFailed extends OfferState {
  String message;

  FetchOffersFailed(this.message);
}

class FetchMoreOffersLoading extends OfferState {}

class FetchMoreOffersSucceed extends OfferState {}

class FetchMoreOffersFailed extends OfferState {
  String message;

  FetchMoreOffersFailed(this.message);
}

class GetUserOffersLoading extends OfferState {}

class GetUserOffersDone extends OfferState {
  List<Offer> offers;

  GetUserOffersDone(this.offers);
}

class GetUserOffersFailed extends OfferState {
  String message;

  GetUserOffersFailed(this.message);
}

class GetMyLikedOffersLoading extends OfferState {}

class GetMyLikedOffersDone extends OfferState {
  List<Offer> offers;

  GetMyLikedOffersDone(this.offers);
}

class GetMyLikedOffersFailed extends OfferState {
  String message;

  GetMyLikedOffersFailed(this.message);
}

class GetFilteredOffersLoading extends OfferState {}

class GetFilteredOffersDone extends OfferState {
  List<Offer> offers;

  GetFilteredOffersDone(this.offers);
}

class GetFilteredOffersFailed extends OfferState {
  String message;

  GetFilteredOffersFailed(this.message);
}