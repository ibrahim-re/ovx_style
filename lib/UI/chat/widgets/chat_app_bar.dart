import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/chats/chats_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/message_model.dart';
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

class _ChatAppBarState extends State<ChatAppBar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  ChatsRepositoryImpl chatsRepositoryImpl = ChatsRepositoryImpl();

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
        BlocBuilder<ChatBloc, ChatStates>(
          builder: (ctx, state) {
            if (state is GetContactsFailed ||
                state is GetGroupsFailed ||
                state is GetUserChatsFailed)
              return Container();
            else
              return AddChatIcon(
                selectedIndex: selectedIndex,
              );
          },
        ),
        //only show filter on contacts screen
        if (selectedIndex == 0)
          IconButton(
            onPressed: () {
              ModalSheets().showFilter(context, CountriesFor.Chat);
            },
            icon: SvgPicture.asset('assets/images/filter.svg'),
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
        labelStyle:
            Constants.TEXT_STYLE4.copyWith(color: MyColors.secondaryColor),
        unselectedLabelColor: MyColors.black,
        tabs: [
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'contacts'.tr(),
            ),
          ),
          StreamBuilder<List<UnreadMessage>>(
            stream: chatsRepositoryImpl
                .checkForUnreadMessages(SharedPref.getUser().id!),
            builder: (ctx, snapshot) {
              List<UnreadMessage> unreadMessages = [];
              // int unreadMessages = 0;
              if (snapshot.hasData) {
                unreadMessages = snapshot.data!;
                unreadMessages.removeWhere(
                    (unreadMessage) => unreadMessage.chatType == 'group');
              }

              print('unread chat ${unreadMessages.length}');
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'chats'.tr(),
                    ),
                  ),
                  if (unreadMessages.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Badge(
                        badgeContent: Text(
                          '${unreadMessages.length}',
                          style: TextStyle(
                              fontSize: 10, color: MyColors.primaryColor),
                        ),
                        badgeColor: MyColors.red,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                ],
              );
            },
          ),
          StreamBuilder<List<UnreadMessage>>(
            stream: chatsRepositoryImpl
                .checkForUnreadMessages(SharedPref.getUser().id!),
            builder: (ctx, snapshot) {
              List<UnreadMessage> unreadMessages = [];
              // int unreadMessages = 0;
              if (snapshot.hasData) {
                unreadMessages = snapshot.data!;
                unreadMessages.removeWhere(
                    (unreadMessage) => unreadMessage.chatType == 'chat');
              }
              ;
              print('unread group ${unreadMessages.length}');
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'groups'.tr(),
                    ),
                  ),
                  if (unreadMessages.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Badge(
                        badgeContent: Text(
                          '${unreadMessages.length}',
                          style: TextStyle(
                              fontSize: 10, color: MyColors.primaryColor),
                        ),
                        badgeColor: MyColors.red,
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
