import 'package:flutter/material.dart';
import 'package:ovx_style/UI/widgets/add_chat_icon.dart';
import 'package:ovx_style/UI/widgets/filter_icon.dart';
import 'package:ovx_style/Utiles/colors.dart';

import '../../widgets/notification_icon.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key, required this.getSelectedIndex})
      : super(key: key);

  final Function getSelectedIndex;
  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size(double.maxFinite, 80);
}

class _ChatAppBarState extends State<ChatAppBar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  late TabController con;
  @override
  void initState() {
    super.initState();
    con = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Chat',
        style: TextStyle(
          fontSize: 18,
          color: MyColors.secondaryColor,
        ),
      ),
      actions: [
        NotificationIcon(),
        AddChatIcon(),
        FilterIcon(ontap: () {}),
      ],
      bottom: TabBar(
        labelPadding: EdgeInsets.only(bottom: 10),
        controller: con,
        indicatorWeight: 3,
        indicatorColor: MyColors.secondaryColor,
        onTap: (int index) {
          setState(() => selectedIndex = index);
          widget.getSelectedIndex(index);
        },
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: MyColors.secondaryColor,
        labelStyle: TextStyle(
          fontSize: 16,
          color: MyColors.secondaryColor,
        ),
        unselectedLabelColor: Colors.black,
        tabs: [
          Text('Contacts'),
          Text('Chat'),
        ],
      ),
    );
  }
}
