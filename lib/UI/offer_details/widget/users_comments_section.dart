import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/UI/offer_details/widget/commentBuilder.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_events.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_states.dart';
import 'package:ovx_style/model/comment_model.dart';

class UsersComments extends StatelessWidget {
  const UsersComments({
    Key? key,
    required this.offerId,
    required this.usersComment,
  }) : super(key: key);

  final String offerId;
  final List<comment> usersComment;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<addComment>(context);
    final User user;
    return BlocConsumer<addComment, addCommentStates>(
      listener: (context, state) {
        if (state is addCommentLoadingState) {
          EasyLoading.showToast('Please Wait ...');
        }

        if (state is addCommentDoneState) {
          bloc.add(fetchComments(offerId));
        }

        if (state is fetchCommentsDoneState) {
          usersComment.clear();
          state.offerComments.forEach((element) {
            usersComment.add(comment.fromJson(element));
          });
        }

        if (state is deleteCommentDoneState) {
          bloc.add(fetchComments(offerId));
        }
      },
      builder: (context, state) {
        return usersComment.isEmpty
            ? Center(
                child: Text(
                'No comments Yet',
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.lightBlue,
                ),
              ))
            : Container(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    return commentBuilder(
                      userId: usersComment[index].ownerId.toString(),
                      comment: usersComment[index].content.toString(),
                      offerId: offerId,
                      userImage: usersComment[index].userImage.toString(),
                      userName: usersComment[index].userName.toString(),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 0),
                  itemCount: usersComment.length,
                ),
              );
      },
    );
  }
}
