abstract class AddOfferState {}

class AddOfferStateInitial extends AddOfferState {}

class AddOfferLoading extends AddOfferState {}

class AddOfferSucceed extends AddOfferState {}

class AddOfferFailed extends AddOfferState {
  String message;

  AddOfferFailed(this.message);
}