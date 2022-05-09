import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/chat/chat_screen.dart';
import 'package:ovx_style/UI/profile/user_profile_screen.dart';
import 'package:ovx_style/UI/story/story_screen.dart';
import 'package:ovx_style/UI/widgets/custom_navigation_bar.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_bloc.dart';
import 'package:ovx_style/model/message_model.dart';
import 'offers/company_offers_screen.dart';
import 'offers/offers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.navigator}) : super(key: key);

  final GlobalKey<NavigatorState> navigator;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //default screen
  int selectedIndex = 0;

  //to change screen index
  void changeIndex(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  //list of screens
  List<Widget> screens = [
    OffersScreen(),
    StoryScreen(),
    ChatScreen(),
    CompanyOffersScreen(),
    BlocProvider(
      create: (ctx) => LogoutBloc(),
      child: UserProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedIndex,
        changeIndex: changeIndex,
      ),
    );
  }
}
