import 'package:flutter/material.dart';
import 'add_chat_icon.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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

class _ChatAppBarState extends State<ChatAppBar> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  late TabController con;
  @override
  void initState() {
    super.initState();
    con = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'chat'.tr(),
        style: TextStyle(
          fontSize: 18,
          color: MyColors.secondaryColor,
        ),
      ),
      actions: [
        NotificationIcon(),
        AddChatIcon(
          selectedIndex: selectedIndex,
        ),
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
        indicatorSize: TabBarIndicatorSize.tab,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        labelColor: MyColors.secondaryColor,
        unselectedLabelStyle: Constants.TEXT_STYLE4,
        labelStyle: Constants.TEXT_STYLE4.copyWith(color: MyColors.secondaryColor),
        unselectedLabelColor: MyColors.black,
        tabs: [
          Text('contacts'.tr()),
          Text('chats'.tr()),
          Text('groups'.tr()),
        ],
      ),
    );
  }
}
