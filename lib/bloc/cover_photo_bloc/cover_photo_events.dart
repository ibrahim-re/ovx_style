
class CoverPhotoEvent {}

class ChangeCoverPhotoButtonPressed extends CoverPhotoEvent {
  String coverImagePath;

  ChangeCoverPhotoButtonPressed(this.coverImagePath);
}