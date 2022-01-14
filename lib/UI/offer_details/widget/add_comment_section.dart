import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_events.dart';
import 'package:ovx_style/bloc/comments_bloc/add_comment_states.dart';

class AddCommentSection extends StatefulWidget {
  AddCommentSection({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final String offerId;
  @override
  State<AddCommentSection> createState() => _AddCommentSectionState();
}

class _AddCommentSectionState extends State<AddCommentSection> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<addComment>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: Image(
                      image: NetworkImage(
                    SharedPref.currentUser.profileImage!,
                  )).image,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Comment',
                  ),
                  onSubmitted: (String value) {
                    setState(
                      () => commentController.text = value,
                    );
                  },
                )),
                IconButton(
                    splashRadius: 10,
                    onPressed: () {
                      bloc.add(
                        addCommentButtonPressed(
                            SharedPref.currentUser.id!,
                            widget.offerId,
                            commentController.text.trim(),
                            SharedPref.currentUser.userName!,
                            SharedPref.currentUser.profileImage!),
                      );

                      commentController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: MyColors.secondaryColor,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
