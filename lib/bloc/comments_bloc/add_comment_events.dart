abstract class addCommentEvent {}

class addCommentButtonPressed extends addCommentEvent {
  String content;
  String userId;
  String offerId;
  String userName;
  String userImage;

  addCommentButtonPressed(
    this.userId,
    this.offerId,
    this.content,
    this.userName,
    this.userImage,
  );
}

class fetchComments extends addCommentEvent {
  String offerId;
  fetchComments(this.offerId);
}

class deleteComment extends addCommentEvent {
  Map<String, dynamic> data;
  String offerId;
  deleteComment(this.offerId, this.data);
}
