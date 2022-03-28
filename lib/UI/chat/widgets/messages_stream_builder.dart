import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:provider/src/provider.dart';

import 'message_align.dart';

class MessagesStreamBuilder extends StatefulWidget {
  final roomId;

  MessagesStreamBuilder({required this.roomId});

  @override
  State<MessagesStreamBuilder> createState() => _MessagesStreamBuilderState();
}

class _MessagesStreamBuilderState extends State<MessagesStreamBuilder> {
  final scrollController = ScrollController();
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
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
            .add(GetMoreMessages(widget.roomId, lastFetchedMessageId));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: _databaseRepositoryImpl.getChatMessages(widget.roomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('error occurred'.tr()),
          );
        }
        if (snapshot.hasData) {
          List<Message> fetchedMessages = snapshot.data!;
          //List<Message> fetchedMessages = messages.values.toList().reversed.toList();

          //initialize last fetched message id value for first time
          if(fetchedMessages.isNotEmpty)
            lastFetchedMessageId = fetchedMessages.last.msgId ?? '';

          return BlocBuilder<ChatBloc, ChatStates>(
            builder: (ctx, state) {
              if (state is GetMoreMessagesDone) {
                fetchedMessages.addAll(state.messages);
                //update last fetched message id to use it to fetch more messages
                lastFetchedMessageId = fetchedMessages.last.msgId ?? '';
              }

              return ListView.separated(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: fetchedMessages.length + 1,
                separatorBuilder: (ctx, index) => const SizedBox(
                  height: 12,
                ),
                itemBuilder: (ctx, index) {
                  if (index < fetchedMessages.length)
                    return MessageAlign(
                        msg: fetchedMessages[index].msgValue!,
                        sender: fetchedMessages[index].sender!,
                        type: fetchedMessages[index].msgType!);
                  else
                    return state is GetMoreMessagesLoading
                        ? Center(
                            child: RefreshProgressIndicator(
                              color: MyColors.secondaryColor,
                            ),
                          )
                        : state is GetMoreMessagesFailed
                            ? Center(
                                child: Text(
                                  state.message,
                                  style: Constants.TEXT_STYLE7,
                                ),
                              )
                            : Container();
                },
              );
            },
          );
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
  }
}
