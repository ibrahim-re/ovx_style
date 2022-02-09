import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  @override
  Widget build(BuildContext context) {

    //no chat available for companies
    if(SharedPref.getUser().userType == UserType.Company.toString())
      return NoDataWidget(text: 'Chat is not available for companies', iconName: 'chat',);

    else
      return Center();
  }
}
