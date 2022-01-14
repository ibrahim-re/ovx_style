import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_events.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_states.dart';
import 'package:ovx_style/model/comment_model.dart';

class addComment extends Bloc<addCommentEvent, addCommentStates> {
  addComment() : super(addCommentInitialState());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();
  DatabaseRepositoryImpl userImp = DatabaseRepositoryImpl();

  @override
  Stream<addCommentStates> mapEventToState(addCommentEvent event) async* {
    if (event is addCommentButtonPressed) {
      try {
        yield addCommentLoadingState();
        // send comment to firebase
        await offersRepositoryImpl.addCommentToOffer(
          event.offerId,
          {
            'userId': event.userId,
            'content': event.content,
            'userImage': event.userImage,
            'userName': event.userName,
          },
        );
        yield addCommentDoneState();
      } catch (e) {
        yield addCommentFailedState('Error in Add Comeent');
      }
    }

    if (event is fetchComments) {
      try {
        DocumentSnapshot result =
            await offersRepositoryImpl.fetchOfferComments(event.offerId);

        yield fetchCommentsDoneState(result.get('comments'));
      } catch (e) {
        yield fetchCommentsFailedState();
      }
    }

    if (event is deleteComment) {
      try {
        await offersRepositoryImpl.deleteComment(event.offerId, event.data);
        yield deleteCommentDoneState();
      } catch (e) {
        yield deleteCommentFailedState();
      }
    }
  }
}
