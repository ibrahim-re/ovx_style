import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/chat_app_bar.dart';
import 'package:ovx_style/UI/chat/widgets/chats_screen.dart';
import 'package:ovx_style/UI/chat/widgets/contacts_screen.dart';
import 'package:ovx_style/UI/widgets/guest_sign_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_state.dart';
import 'package:provider/src/provider.dart';
import 'widgets/group/groups_screen.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  int selectedIndex = 0;
  List<Widget> _screens = [
    ContactsScreen(),
    ChatsScreen(),
    // here we have groups that user is part of
    GroupsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //no chat available for guests
    if (SharedPref.getUser().userType == UserType.Guest.toString())
      return Center(
        child: NoDataWidget(
          text: 'chat is not available for guests'.tr(),
          iconName: 'chat',
          child: GuestSignWidget(),
        ),
      );
    else
      return Scaffold(
        appBar: ChatAppBar(
                getSelectedIndex: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
        body: Column(
                children: [
                  ChatAvailableDaysWidget(),
                  Expanded(child: _screens[selectedIndex]),
                ],
              ),
      );
  }
}

class ChatAvailableDaysWidget extends StatefulWidget {
  @override
  _ChatAvailableDaysWidgetState createState() =>
      _ChatAvailableDaysWidgetState();
}

class _ChatAvailableDaysWidgetState extends State<ChatAvailableDaysWidget> {
  @override
  void initState() {
    context.read<PackagesBloc>().add(GetChatAvailableDays());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesBloc, PackagesState>(builder: (ctx, state) {
      if (state is GetChatAvailableDaysFailed)
        return Center(
          child: Text(
            state.message,
            style: Constants.TEXT_STYLE4,
            textAlign: TextAlign.center,
          ),
        );
      else if(state is GetChatAvailableDaysLoading)
        return Center(
          child: RefreshProgressIndicator(
            color: MyColors.secondaryColor,
          ),
        );
      else{
        int availableDays = context.read<PackagesBloc>().chatAvailableDays;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          height: 50,
          decoration: BoxDecoration(
            color: MyColors.lightBlue.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/info.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(
                'you have'.tr() +
                    ' ${availableDays} ' +
                    'days available'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
            ],
          ),
        );
      }
    });
  }
}
