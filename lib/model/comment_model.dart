class comment {
  String? ownerId;
  String? content;
  String? userName;
  String? userImage;

  comment.fromJson(Map<String, dynamic> json) {
    ownerId = json['userId'];
    content = json['content'];
    userName = json['userName'];
    userImage = json['userImage'];
  }
}
