
class EditUserEvent {}

class EditUserButtonPressed extends EditUserEvent {
  Map<String, dynamic> userData;
  String profileImage;
  //for company
  List<String> regImages;

  EditUserButtonPressed(this.userData, this.profileImage, this.regImages);
}