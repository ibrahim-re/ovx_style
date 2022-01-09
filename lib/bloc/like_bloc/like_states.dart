
abstract class LikeState {}

class LikeInitialState extends LikeState {}

class LikeDone extends LikeState {}

class LikeFailed extends LikeState {
  String message;

  LikeFailed(this.message);
}