import 'package:ovx_style/model/comment_model.dart';


class CommentState {}

class CommentsInitialState extends CommentState {}

class FetchCommentsLoadingState extends CommentState {}

class AddCommentLoadingState extends CommentState {

}

class DeleteCommentLoadingState extends CommentState {

}

class FetchCommentsDoneState extends CommentState {
  final List<CommentModel> offerComments;
  FetchCommentsDoneState(this.offerComments);
}

class FetchCommentsFailedState extends CommentState {
  final String message;

  FetchCommentsFailedState(this.message);

}

class AddCommentFailedState extends CommentState {
 final String message;

 AddCommentFailedState(this.message);
}

class DeleteCommentFailedState extends CommentState {
  final String message;

  DeleteCommentFailedState(this.message);
}