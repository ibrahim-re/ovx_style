import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/comment_model.dart';

import 'comment_events.dart';
import 'comment_states.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentsInitialState());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();
  DatabaseRepositoryImpl userImp = DatabaseRepositoryImpl();

  List<CommentModel> _comments = [];

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is FetchComments) {
      yield FetchCommentsLoadingState();
      try {

        _comments = await offersRepositoryImpl.fetchOfferComments(event.offerId, event.offerOwnerId);

        yield FetchCommentsDoneState(_comments);
      } catch (e) {
        yield FetchCommentsFailedState('error occurred'.tr());
      }
    } else if (event is AddCommentButtonPressed) {
      yield AddCommentLoadingState();
      try {
        //generate id for comment
        String id = Helper().generateRandomName();

        // send comment to firebase
        await offersRepositoryImpl.addCommentToOffer(
          event.offerId,
          event.offerOwnerId,
          {
            'id': id,
            'userId': event.userId,
            'content': event.content,
            'userImage': event.userImage,
            'userName': event.userName,
          },
        );

        //add the new comment to the local version of comments to update UI
        _comments.add(CommentModel.fromMap({
          'id': id,
          'userId': event.userId,
          'content': event.content,
          'userImage': event.userImage,
          'userName': event.userName,
        }));

        yield FetchCommentsDoneState(_comments);
      } catch (e) {
        yield AddCommentFailedState('error occurred'.tr());
      }
    } else if (event is DeleteCommentButtonPressed) {
      yield DeleteCommentLoadingState();
      try {
        await offersRepositoryImpl.deleteComment(event.offerId, event.data, event.offerOwnerId);

        //remove the comment from the local version of comments to update UI
        CommentModel c = CommentModel.fromMap(event.data);

       _comments.removeWhere((comment) => comment.id == c.id);


        yield FetchCommentsDoneState(_comments);
      } catch (e) {
        yield DeleteCommentFailedState('error occurred'.tr());
      }
    }
  }
}
