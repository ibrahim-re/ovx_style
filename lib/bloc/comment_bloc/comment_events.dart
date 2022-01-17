
class CommentEvent {}

class FetchComments extends CommentEvent {
  String offerId;
  String offerOwnerId;

  FetchComments(this.offerId, this.offerOwnerId);
}

class AddCommentButtonPressed extends CommentEvent {
  String content;
  String userId;
  String offerId;
  String userName;
  String userImage;
  String offerOwnerId;

  AddCommentButtonPressed(
      this.userId,
      this.offerId,
      this.content,
      this.userName,
      this.userImage,
      this.offerOwnerId,
      );
}

class DeleteCommentButtonPressed extends CommentEvent {
  Map<String, dynamic> data;
  String offerId;
  String offerOwnerId;

  DeleteCommentButtonPressed(this.offerId, this.data, this.offerOwnerId);
}