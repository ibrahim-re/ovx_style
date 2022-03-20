import 'package:flutter/material.dart';
import 'package:ovx_style/UI/chat/widgets/chat_app_bar.dart';
import 'package:ovx_style/UI/chat/widgets/chats_screen.dart';
import 'package:ovx_style/UI/chat/widgets/contacts_screen.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool? isCompany;

  @override
  void initState() {
    if (isCompany == null) {
      setState(() {
        isCompany = typeValidation();
      });
    }
    super.initState();
  }

  bool typeValidation() {
    return SharedPref.getUser().userType == UserType.Company.toString();
  }

  int selectedIndex = 0;
  List<Widget> _screens = [
    // here we have all users in the app
    ContactsScreen(),
    // here we have users in app who have conversation between logged user and them
    ChatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isCompany!
          ? null
          : ChatAppBar(
              getSelectedIndex: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
      body: isCompany!
          ? Center(
              child: NoDataWidget(
              text: 'Chat is not available for companies',
              iconName: 'chat',
            ))
          : _screens[selectedIndex],
    );
  }
}
