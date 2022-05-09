class CommentModel {
  String? id;
  String? ownerId;
  String? content;
  String? userName;
  String? userImage;

  CommentModel({
    this.id,
    this.userName,
    this.userImage,
    this.content,
    this.ownerId,
  });

  CommentModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    ownerId = map['ownerId'];
    content = map['content'];
    userName = map['userName'];
    userImage = map['userImage'];
  }
}
