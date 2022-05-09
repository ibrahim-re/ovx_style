import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/chats/chats_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer_image/shimmer_image.dart';

import '../message_align.dart';

class GroupMessagesStreamBuilder extends StatefulWidget {
  final String groupId;

  GroupMessagesStreamBuilder({required this.groupId});

  @override
  _GroupMessagesStreamBuilderState createState() =>
      _GroupMessagesStreamBuilderState();
}

class _GroupMessagesStreamBuilderState
    extends State<GroupMessagesStreamBuilder> {
  final scrollController = ScrollController();
  ChatsRepositoryImpl _chatsRepositoryImpl = ChatsRepositoryImpl();
  String lastFetchedMessageId = '';

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        print('end of list');
        context
            .read<ChatBloc>()
            .add(GetMoreGroupMessages(widget.groupId, lastFetchedMessageId));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroupMessage>>(
      stream: _chatsRepositoryImpl.getGroupChatMessages(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('error occurred'.tr()),
          );
        }
        if (snapshot.hasData) {
          List<GroupMessage> fetchedMessages = snapshot.data!;

          //initialize last fetched message id value for first time
          if (fetchedMessages.isNotEmpty)
            lastFetchedMessageId = fetchedMessages.last.msgId ?? '';

          return BlocBuilder<ChatBloc, ChatStates>(builder: (ctx, state) {
            if (state is GetMoreGroupMessagesDone) {
              fetchedMessages.addAll(state.messages);
              //update last fetched message id to use it to fetch more messages
              lastFetchedMessageId = fetchedMessages.last.msgId ?? '';
            }

            return ListView.separated(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: fetchedMessages.length + 1,
                separatorBuilder: (ctx, index) => const SizedBox(
                      height: 12,
                    ),
                itemBuilder: (ctx, index) {
                  if (index < fetchedMessages.length) {
                    bool isMe = SharedPref.getUser().id == fetchedMessages[index].sender;
                    return Column(
                      children: [
                        if(!isMe)
                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 10,
                              child: fetchedMessages[index].senderImage != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: ProgressiveImage(
                                        imageError:
                                            'assets/images/no_internet.png',
                                        image:
                                            fetchedMessages[index].senderImage!,
                                        height: 20,
                                        width: 20,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 10,
                                      backgroundImage: AssetImage(
                                          'assets/images/default_profile.jpg'),
                                    ),
                            ),
                            if(!isMe)
                              const SizedBox(
                              width: 6,
                            ),
                            Text(
                              fetchedMessages[index].senderName!,
                              style: Constants.TEXT_STYLE6,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        MessageAlign(
                            msg: fetchedMessages[index].msgValue!,
                            sender: fetchedMessages[index].sender!,
                            type: fetchedMessages[index].msgType!),
                      ],
                    );
                  } else
                    return state is GetMoreGroupMessagesLoading
                        ? Center(
                            child: RefreshProgressIndicator(
                              color: MyColors.secondaryColor,
                            ),
                          )
                        : state is GetMoreGroupMessagesFailed
                            ? Center(
                                child: Text(
                                  state.message,
                                  style: Constants.TEXT_STYLE7,
                                ),
                              )
                            : Container();
                });
          });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.secondaryColor,
            ),
          );
        } else
          return Container();
      },
    );
    ;
  }
}
