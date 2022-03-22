import 'package:flutter/material.dart';
import 'widgets/group/group_messages_stream_builder.dart';
import 'package:ovx_style/UI/chat/widgets/sending_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/group_model.dart';

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen({
    Key? key,
    this.navigator,
    required this.groupModel,
  }) : super(key: key);

  final navigator;
  final GroupModel groupModel;
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: MyColors.grey,
              child: Center(child: Text('G', style: Constants.TEXT_STYLE8,)),
            ),
            SizedBox(width: 10),
            Text(
              widget.groupModel.groupName!,
              style: Constants.TEXT_STYLE8,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupMessagesStreamBuilder(
              groupId: widget.groupModel.groupId!,
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
              roomId: widget.groupModel.groupId,
              chatType: ChatType.Group,
            ),
          ),
        ],
      ),
    );
  }
}
