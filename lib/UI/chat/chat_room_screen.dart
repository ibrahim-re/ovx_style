import 'package:flutter/cupertino.dart';
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
              radius: 30,
              child: widget.anotherUserImage == 'no image'
                  ? Image.asset(
                      'assets/images/default_profile.png',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.anotherUserImage,
                      fit: BoxFit.cover,
                    ),
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
            child: MessagesStreamBuilder(
              roomId: widget.roomId,
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            decoration: BoxDecoration(color: MyColors.primaryColor, boxShadow: [
              BoxShadow(
                color: MyColors.grey,
                offset: Offset(0, 0),
                blurRadius: 6,
              ),
            ]),
            child: SendingWidget(
              roomId: widget.roomId,
            ),
          ),
        ],
      ),
    );
  }
}