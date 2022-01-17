import 'package:flutter/material.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {

    //no chat available for companies
    if(SharedPref.currentUser.userType == UserType.Company.toString())
      return NoPermissionWidget(text: 'Chat is not available for companies', iconName: 'chat',);

    else
      return Center();
  }
}
