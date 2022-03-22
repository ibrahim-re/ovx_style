import 'package:flutter/material.dart';
import 'package:ovx_style/UI/chat/widgets/messages_stream_builder.dart';
import 'package:ovx_style/UI/chat/widgets/sending_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen({
    Key? key,
    this.navigator,
    required this.anotherUserName,
    required this.anotherUserImage,
    required this.roomId,
  }) : super(key: key);

  final navigator;
  final String anotherUserName;
  final String anotherUserImage;
  final String roomId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  //String uploadedImageUrl = '';

  @override
  void dispose() {
    print('dispoosed again');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: widget.anotherUserImage == 'no image'
                  ? Image(
                      image: AssetImage('assets/images/default_profile.png'),
                    ).image
                  : Image(image: NetworkImage(widget.anotherUserImage)).image,
            ),
            SizedBox(width: 10),
            Text(
              widget.anotherUserName,
              style: Constants.TEXT_STYLE8,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesStreamBuilder(roomId: widget.roomId),
          ),
          Container(
            decoration: BoxDecoration(color: MyColors.primaryColor, boxShadow: [
              BoxShadow(
                color: MyColors.grey.withOpacity(.4),
                offset: Offset(0, 0),
                blurRadius: 8,
              ),
            ]),
            child: SendingWidget(roomId: widget.roomId),
          ),
        ],
      ),
    );
  }
}
