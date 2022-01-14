import 'package:ovx_style/model/comment_model.dart';

abstract class addCommentStates {}

class addCommentInitialState extends addCommentStates {}

class addCommentLoadingState extends addCommentStates {}

class addCommentDoneState extends addCommentStates {}

class addCommentFailedState extends addCommentStates {
  final String errorMessage;
  addCommentFailedState(this.errorMessage);
}

class fetchCommentsDoneState extends addCommentStates {
  final List<dynamic> offerComments;
  fetchCommentsDoneState(this.offerComments);
}

class fetchCommentsFailedState extends addCommentStates {}

class deleteCommentDoneState extends addCommentStates {}

class deleteCommentFailedState extends addCommentStates {}
