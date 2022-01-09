import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> userData = [
    {
      'title': 'Offers',
      'number': SharedPref.currentUser.offersAdded?.length ?? 0,
    },
    {
      'title': 'Likes',
      'number': SharedPref.currentUser.offersLiked?.length ?? 0,
    },
    {
      'title': 'Profile',
      'number': 1742,
    },
    {
      'title': 'Gifts',
      'number': 77,
    },
    {
      'title': 'Points',
      'number': SharedPref.currentUser.points ?? 0,
    },
  ];
  @override
  Widget build(BuildContext context) {
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
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => infoItemBuilder(
                title: userData[index]['title'],
                number: userData[index]['number'],
                elementSize: MediaQuery.of(context).size.width / userData.length,
              ),
              separatorBuilder: (_, index) => Container(
                width: 1,
                height: 50,
                color: Colors.grey.shade200,
              ),
              itemCount: userData.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              SharedPref.currentUser.shortDesc ?? '',
              textAlign: TextAlign.center,
              style: Constants.TEXT_STYLE4,),
          ),
        ],
      ),
    );
  }
}

Widget infoItemBuilder({
  required String title,
  required int number,
  required double elementSize,
}) {
  return Container(
    width: elementSize,
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
  );
}
