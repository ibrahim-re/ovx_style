import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_bloc.dart';
import 'package:ovx_style/bloc/comment_bloc/comment_events.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/model/user.dart';

class CommentBuilder extends StatelessWidget {
  const CommentBuilder({
    Key? key,
    required this.commentId,
    required this.userId,
    required this.offerOwnerId,
    required this.comment,
    required this.offerId,
    required this.userImage,
    required this.userName,
  }) : super(key: key);

  final String userId,
      comment,
      offerId,
      userImage,
      userName,
      commentId,
      offerOwnerId;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommentBloc>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {

              //check if offer owner is the logged in user
              if(userId == SharedPref.getUser().id)
                NamedNavigatorImpl().push(NamedRoutes.USER_PROFILE_SCREEN);
              else{
                User user = await AuthHelper.getUser(userId);
                NamedNavigatorImpl().push(NamedRoutes.OTHER_USER_PROFILE, arguments: {'user': user});
              }

            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: userImage != ''
                  ? Image.network(userImage).image
                  : AssetImage('assets/images/default_profile.jpg'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.toString(),
                  style: Constants.TEXT_STYLE4
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  comment,
                  //style: Theme.of(context).textTheme.caption,
                  style: TextStyle(
                    color: MyColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          CustomPopUpMenu(
            ownerId: userId,
            deleteFunction: () {
              bloc.add(
                DeleteCommentButtonPressed(
                  offerId,
                  {
                    'id': commentId,
                    'content': comment,
                    'userId': userId,
                    'userName': userName,
                    'userImage': userImage,
                  },
                  offerOwnerId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
