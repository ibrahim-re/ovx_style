import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_events.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_states.dart';
import 'package:ovx_style/model/user.dart';

class commentBuilder extends StatelessWidget {
  const commentBuilder({
    Key? key,
    required this.userId,
    required this.comment,
    required this.offerId,
    required this.userImage,
    required this.userName,
  }) : super(key: key);

  final String userId, comment, offerId, userImage, userName;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<addComment>(context);
    return BlocConsumer<addComment, addCommentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(
                radius: 15,
                backgroundImage:
                    Image(image: NetworkImage(userImage.toString())).image,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      comment,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  offset: Offset(-10, 40),
                  padding: const EdgeInsets.all(0),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primaryColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem(
                        height: 4,
                        onTap: () {
                          bloc.add(
                            deleteComment(
                              offerId,
                              {
                                'content': comment,
                                'userId': userId,
                                'userName': userName,
                                'userImage': userImage,
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete),
                            const SizedBox(width: 10),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ]),
          );
        });
  }
}
