import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/roomModel.dart';

class MessagesStreamBuilder extends StatefulWidget {
  final roomId;

  MessagesStreamBuilder({required this.roomId});

  @override
  State<MessagesStreamBuilder> createState() => _MessagesStreamBuilderState();
}

class _MessagesStreamBuilderState extends State<MessagesStreamBuilder> {
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
  late Stream<Map<String, Message>> messagesStream;

  @override
  void initState() {
    print('starting');
    messagesStream = _databaseRepositoryImpl.getChatMessages(widget.roomId);
    super.initState();
  }

  @override
  void dispose() {
    print('dissposed');
    messagesStream = Stream.empty();
    super.dispose();
  }

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
          List<Message> fetchedMessages = messages.values.toList().reversed.toList();

          print('messages is ${fetchedMessages}');
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

class MessageAlign extends StatelessWidget {
  final String sender, msg;
  final int type;

  MessageAlign({
    required this.msg,
    required this.sender,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    bool isMe = SharedPref.getUser().id == sender;
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color: isMe ? MyColors.lightBlue.withOpacity(0.2) : MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: MessageShape(
          type: type,
          isMe: isMe,
          msg: msg,
        ),
      ),
    );
  }
}

class MessageShape extends StatelessWidget {
  final String msg;
  final bool isMe;
  final int type;

  MessageShape({
    required this.msg,
    required this.isMe,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          msg,
          style: Constants.TEXT_STYLE6.copyWith(color: isMe ? MyColors.black : Colors.white,),
        ),
      );
    }
    // if (type == 1) {
    //   msg = msg == '' ? uploadedImageUrl : msg;
    //   return msg != ''
    //       ? ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child: GestureDetector(
    //             onTap: () {
    //               showDialog(
    //                   context: context,
    //                   builder: (ctx) => AlertDialog(
    //                         insetPadding: EdgeInsets.zero,
    //                         actionsPadding: EdgeInsets.zero,
    //                         contentPadding: EdgeInsets.zero,
    //                         titlePadding: EdgeInsets.zero,
    //                         buttonPadding: EdgeInsets.zero,
    //                         content: Container(
    //                           padding: EdgeInsets.zero,
    //                           child: FittedBox(
    //                               child: Image(image: NetworkImage(msg))),
    //                         ),
    //                       ));
    //             },
    //             child: FadeInImage(
    //               placeholder: AssetImage('assets/images/loader-animation.gif'),
    //               image: NetworkImage(msg != '' ? msg : uploadedImageUrl),
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //         )
    //       : Center(
    //           child: CircularProgressIndicator(
    //             color: MyColors.secondaryColor,
    //           ),
    //         );
    // }

    return Container();
  }
}
