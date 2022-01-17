
abstract class LikeEvent {}

class LikeButtonPressed extends LikeEvent {
  String offerId;
  String offerOwnerId;
  String userId;

  LikeButtonPressed(this.offerId, this.offerOwnerId, this.userId);
}