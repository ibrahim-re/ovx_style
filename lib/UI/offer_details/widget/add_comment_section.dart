import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_bloc.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_events.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_states.dart';

class AddCommentSection extends StatefulWidget {
  AddCommentSection({
    Key? key,
    required this.offerId,
    required this.offerOwnerId,
  }) : super(key: key);

  final String offerId;
  final String offerOwnerId;

  @override
  State<AddCommentSection> createState() => _AddCommentSectionState();
}

class _AddCommentSectionState extends State<AddCommentSection> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommentBloc>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'comments'.tr(),
            style: Constants.TEXT_STYLE8.copyWith(fontSize: 20),
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
                  backgroundImage: SharedPref.getUser().profileImage! != ''
                      ? Image.network(SharedPref.getUser().profileImage!)
                          .image
                      : AssetImage('assets/images/default_profile.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: commentController,
                    cursorColor: MyColors.secondaryColor,
                    cursorWidth: 2,
                    style: Constants.TEXT_STYLE1.copyWith(color: MyColors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'add comment'.tr(),
                      hintStyle: Constants.TEXT_STYLE1,
                    ),
                    onSubmitted: (String value) {
                      commentController.text = value;
                    },
                  ),
                ),
                BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is AddCommentLoadingState)
                      return Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: MyColors.secondaryColor,
                          ),
                        ),
                      );
                    else
                      return IconButton(
                        splashRadius: 10,
                        onPressed: () {
                          if(commentController.text.isEmpty)
                            return;
                          else
                            bloc.add(
                            AddCommentButtonPressed(
                              SharedPref.getUser().id!,
                              widget.offerId,
                              commentController.text.trim(),
                              SharedPref.getUser().userName!,
                              SharedPref.getUser().profileImage!,
                              widget.offerOwnerId,
                            ),
                          );

                          commentController.clear();
                        },
                        icon: SvgPicture.asset('assets/images/comment.svg', fit: BoxFit.scaleDown, matchTextDirection: true,),
                      );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
