import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

import 'message_shape.dart';

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