
abstract class LikeEvent {}

class LikeButtonPressed extends LikeEvent {
  String offerId;
  String userId;

  LikeButtonPressed(this.offerId, this.userId);
}