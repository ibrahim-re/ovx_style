import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            SharedPref.currentUser.userName ?? '',
            style: Constants.TEXT_STYLE4,
          ),
          const SizedBox(height: 6),
          Text(
            SharedPref.currentUser.userCode ?? '',
            style: Constants.TEXT_STYLE4.copyWith(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                InfoItem(
                  title: 'Offers',
                  number: SharedPref.currentUser.offersAdded?.length ?? 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Likes',
                  number: SharedPref.currentUser.offersLiked?.length ?? 0,
                  route: NamedRoutes.MY_LIKED_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Profit',
                  number: 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Gifts',
                  number: 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: MyColors.lightGrey,
                ),
                InfoItem(
                  title: 'Points',
                  number: SharedPref.currentUser.points ?? 0,
                  route: NamedRoutes.MY_OFFERS_SCREEN,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              SharedPref.currentUser.shortDesc ?? '',
              textAlign: TextAlign.center,
              style: Constants.TEXT_STYLE4,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String title;
  final int number;
  final String route;

  InfoItem({
    required this.title,
    required this.number,
    required this.route,
});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          NamedNavigatorImpl().push(route);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Constants.TEXT_STYLE4,
            ),
            Text(
              number.toString(),
              style: Constants.TEXT_STYLE4.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

