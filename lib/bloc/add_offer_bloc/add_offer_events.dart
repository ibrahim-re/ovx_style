abstract class AddOfferEvent {}

class AddProductOfferButtonPressed extends AddOfferEvent {
  String offerType;

  AddProductOfferButtonPressed(this.offerType);
}

class AddVideoOfferButtonPressed extends AddOfferEvent {
  String offerType;
  List<String> videoPath;

  AddVideoOfferButtonPressed(this.videoPath, this.offerType);
}

class AddImageOfferButtonPressed extends AddOfferEvent {
  String offerType;
  List<String> imagesPath;

  AddImageOfferButtonPressed(this.imagesPath, this.offerType);
}

class AddPostOfferButtonPressed extends AddOfferEvent {
  List<String> imagesPath;
  String shortDesc;
  String offerType;

  AddPostOfferButtonPressed(this.imagesPath, this.shortDesc, this.offerType);
}

class DeleteOfferButtonPressed extends AddOfferEvent {
  String offerId;
  String offerOwnerType;
  String userId;

  DeleteOfferButtonPressed(this.offerId, this.offerOwnerType, this.userId);
}