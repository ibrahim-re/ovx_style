
class CoverPhotoState {}

class ChangeCoverPhotoInitialized extends CoverPhotoState {}

class ChangeCoverPhotoLoading extends CoverPhotoState {}

class ChangeCoverPhotoSuccess extends CoverPhotoState {}

class ChangeCoverPhotoFailed extends CoverPhotoState {
  String message;

  ChangeCoverPhotoFailed(this.message);
}