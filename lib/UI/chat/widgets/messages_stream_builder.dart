import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';

import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/message_model.dart';

import 'message_align.dart';

class MessagesStreamBuilder extends StatefulWidget {
  final roomId;

  MessagesStreamBuilder({required this.roomId});

  @override
  State<MessagesStreamBuilder> createState() => _MessagesStreamBuilderState();
}

class _MessagesStreamBuilderState extends State<MessagesStreamBuilder> {
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, Message>>(
      stream: _databaseRepositoryImpl.getChatMessages(widget.roomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('error occurred'.tr()),
          );
        }
        if (snapshot.hasData) {
          Map<String, Message> messages = snapshot.data!;
          List<Message> fetchedMessages = messages.values.toList();

          return ListView.separated(
            reverse: true,
            padding: const EdgeInsets.all(8),
            itemCount: messages.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12,),
            itemBuilder: (ctx, index) => MessageAlign(
                msg: fetchedMessages[index].msgValue!,
                sender: fetchedMessages[index].sender!,
                type: fetchedMessages[index].msgType!),
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
