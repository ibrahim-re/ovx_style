import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_bloc.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_events.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_states.dart';
import 'package:ovx_style/model/comment_model.dart';

import 'comment_builder.dart';


class UsersComments extends StatefulWidget {
  const UsersComments({
    Key? key,
    required this.offerId,
    required this.offerOwnerId,
  }) : super(key: key);

  final String offerId;
  final String offerOwnerId;

  @override
  State<UsersComments> createState() => _UsersCommentsState();
}

class _UsersCommentsState extends State<UsersComments> {
  //to save fetched comments when state changes
  List<CommentModel> fetchedComments = [];

  @override
  void initState() {
    context.read<CommentBloc>().add(FetchComments(widget.offerId, widget.offerOwnerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) => {

      },
      builder: (context, state) {
        if(state is FetchCommentsLoadingState)
          return WaitingOfferOwnerRow();

        else if(state is FetchCommentsFailedState)
          return Text(state.message);

        else if(state is FetchCommentsDoneState){
          fetchedComments = state.offerComments;
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return CommentBuilder(
                commentId: state.offerComments[index].id.toString(),
                userId: state.offerComments[index].ownerId.toString(),
                comment: state.offerComments[index].content.toString(),
                offerId: widget.offerId,
                offerOwnerId: widget.offerOwnerId,
                userImage: state.offerComments[index].userImage.toString(),
                userName: state.offerComments[index].userName.toString(),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 0),
            itemCount: state.offerComments.length,
          );
        }

        else return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return CommentBuilder(
                commentId: fetchedComments[index].id.toString(),
                userId: fetchedComments[index].ownerId.toString(),
                comment: fetchedComments[index].content.toString(),
                offerId: widget.offerId,
                offerOwnerId: widget.offerOwnerId,
                userImage: fetchedComments[index].userImage.toString(),
                userName: fetchedComments[index].userName.toString(),
              );
              },
            separatorBuilder: (context, index) => SizedBox(height: 0),
            itemCount: fetchedComments.length,
        );


      },
    );
  }
}

/*Container(
              height: 300,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  return commentBuilder(
                    userId: state.offerComments[index].ownerId.toString(),
                    comment: state.offerComments[index].content.toString(),
                    offerId: widget.offerId,
                    userImage: state.offerComments[index].userImage.toString(),
                    userName: state.offerComments[index].userName.toString(),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 0),
                itemCount: state.offerComments.length,
              ),
            )*/