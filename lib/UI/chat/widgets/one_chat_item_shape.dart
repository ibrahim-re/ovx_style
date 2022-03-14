import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/model/chatUserModel.dart';
import '../../../Utiles/colors.dart';
import '../../../Utiles/navigation/named_navigator_impl.dart';
import '../../../Utiles/navigation/named_routes.dart';
import '../../../bloc/chat_bloc/chat_event.dart';
import '../../../bloc/chat_bloc/chat_state.dart';

class oneChatItem extends StatelessWidget {
  oneChatItem({Key? key, required this.model}) : super(key: key);
  final ChatUserModel model;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatStates>(
      listener: (context, state) {
        if (state is CreatedRoomDoneState) {
          if (state.anotherUserId == model.userId) {
            NamedNavigatorImpl().push(
              NamedRoutes.ChatRoomScreen,
              arguments: {
                'name': model.userName,
                'image': model.userImage ?? 'no image',
                'roomId': state.roomId,
              },
            );
          }
        }
      },
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            createRoom(
              SharedPref.getUser().id!,
              model.userId!,
            ),
          );
        },
        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: model.userOffers.isNotEmpty ? 33 : 30,
                backgroundColor: model.userOffers.isNotEmpty
                    ? MyColors.secondaryColor
                    : Colors.transparent,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: MyColors.secondaryColor,
                  backgroundImage: model.userImage == 'no image'
                      ? Image.asset('assets/images/default_profile.png').image
                      : NetworkImage(model.userImage!),
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.userName!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      model.userLastMessage!,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
