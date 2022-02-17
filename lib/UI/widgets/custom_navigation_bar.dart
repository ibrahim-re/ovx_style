import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function changeIndex;

  CustomNavigationBar({required this.selectedIndex, required this.changeIndex});

  static const height = 60.0;

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      height: height,
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
      child: ListView.builder(
        itemCount: 5,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            changeIndex(index);
          },
          child: SizedBox(
            width: (width - 16) / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 4,
                  width: selectedIndex == index ? 40 : 0,
                  decoration: BoxDecoration(
                    color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/${assetNames[index]}.svg',
                  color: selectedIndex == index
                      ? MyColors.secondaryColor
                      : MyColors.grey,
                  fit: BoxFit.scaleDown,
                ),
                Text(
                  labelNames[index],
                  style: TextStyle(
                    color: selectedIndex == index
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
      ),
    );
  }
}
