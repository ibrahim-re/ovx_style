import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/model/chatUserModel.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:shimmer_image/shimmer_image.dart';
import '../../../Utiles/colors.dart';
import '../../../Utiles/navigation/named_navigator_impl.dart';
import '../../../Utiles/navigation/named_routes.dart';
import '../../../bloc/chat_bloc/chat_event.dart';
import '../../../bloc/chat_bloc/chat_state.dart';

class OneChatItem extends StatefulWidget {
  OneChatItem({Key? key, required this.model}) : super(key: key);
  final ChatUserModel model;

  @override
  State<OneChatItem> createState() => _OneChatItemState();
}

class _OneChatItemState extends State<OneChatItem> {
  DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final roomId = widget.model.roomId;
    return BlocListener<ChatBloc, ChatStates>(
      listener: (context, state) {
        if (state is CreatedRoomDoneState) {
          if (state.anotherUserId == widget.model.userId)
            NamedNavigatorImpl().push(
              NamedRoutes.ChatRoomScreen,
              arguments: {
                'name': widget.model.userName,
                'image': widget.model.userImage ?? 'no image',
                'roomId': state.roomId,
              },
            );
        }
      },
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            CreateRoom(
              SharedPref.getUser().id!,
              widget.model.userId!,
            ),
          );
        },
        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: widget.model.userOffers.isNotEmpty
                    ? MyColors.secondaryColor
                    : Colors.transparent,
                child: widget.model.userImage != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ProgressiveImage(
                          imageError: 'assets/images/no_internet.png',
                          image: widget.model.userImage!,
                          height: 55,
                          width: 55,
                        ),
                      )
                    : CircleAvatar(
                        radius: widget.model.userOffers.isNotEmpty ? 27 : 30,
                        backgroundImage:
                            AssetImage('assets/images/default_profile.jpg'),
                      ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.userName!,
                      style: Constants.TEXT_STYLE4,
                    ),
                    /*
                    if room id is not null then this chat is exists,
                    show last message as stream to keep update
                    */
                    if (roomId != null && roomId.isNotEmpty)
                      StreamBuilder<Message>(
                        stream: databaseRepositoryImpl.getLastMessage(roomId),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            Message message = snapshot.data!;
                            String msg = message.msgType == 2 ? 'voice message'.tr() : message.msgType == 1 ? 'image message'.tr() : message.msgValue!;
                            bool isRead = true;
                            //if not me who send the message, see if it's read or unread
                            if (message.sender != SharedPref.getUser().id)
                              isRead = message.isRead!;

                            return Row(
                              children: [
                                Text(
                                  msg,
                                  style: isRead
                                      ? Constants.TEXT_STYLE6
                                      : Constants.TEXT_STYLE6.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (!isRead) Spacer(),
                                if (!isRead)
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: MyColors.red,
                                  ),
                              ],
                            );
                          } else
                            return Container();
                        },
                      )
                    else
                      Text(
                        'start chat'.tr(),
                        style: Constants.TEXT_STYLE6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
