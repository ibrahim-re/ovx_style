import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/offers_screen.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function changeIndex;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.changeIndex,
  });

  static const height = 60.0;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final List<String> labelNames = [
    'offers'.tr(),
    'story'.tr(),
    'chat'.tr(),
    'c.offers'.tr(),
    'profile'.tr(),
  ];

  final List<String> assetNames = [
    'offers',
    'story',
    'chat',
    'c_offers',
    'profile',
  ];

  DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      height: CustomNavigationBar.height,
      decoration: const BoxDecoration(
        color: MyColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: MyColors.grey,
            offset: Offset(0, 0),
            blurRadius: 6,
          ),
        ],
      ),
      child: StreamBuilder<int>(
        stream: databaseRepositoryImpl.checkForUnreadMessages(SharedPref.getUser().id!),
        builder: (ctx, snapshot) {
          int unreadMessages = 0;
          if (snapshot.hasData) unreadMessages = snapshot.data!;

          print('unread is $unreadMessages');

          return ListView.builder(
            itemCount: 5,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                widget.changeIndex(index);
              },
              child: SizedBox(
                width: (width - 16) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 4,
                      width: widget.selectedIndex == index ? 40 : 0,
                      decoration: BoxDecoration(
                        color: MyColors.secondaryColor,
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/${assetNames[index]}.svg',
                          color: widget.selectedIndex == index
                              ? MyColors.secondaryColor
                              : MyColors.grey,
                          fit: BoxFit.scaleDown,
                        ),
                        if (index == 2 && unreadMessages > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Badge(
                              badgeColor: Colors.red,
                              padding: const EdgeInsets.all(6),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      labelNames[index],
                      style: TextStyle(
                        color: widget.selectedIndex == index
                            ? MyColors.secondaryColor
                            : MyColors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
