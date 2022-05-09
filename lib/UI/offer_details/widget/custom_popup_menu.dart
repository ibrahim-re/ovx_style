import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class CustomPopUpMenu extends StatelessWidget {
  final ownerId;
  final deleteFunction;
  final shareFunction;
  final reportFunction;
  final color;

  CustomPopUpMenu({this.deleteFunction, required this.reportFunction, required this.ownerId, this.color = MyColors.lightBlue, required this.shareFunction});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: color,
      ),
      //iconSize: 25,
      offset: Offset(-10, 40),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      itemBuilder: (_) {
        return [
          if (ownerId == SharedPref.getUser().id)
            PopupMenuItem(
              height: 4,
              onTap: deleteFunction ?? () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: MyColors.black),
                  const SizedBox(width: 10),
                  Text(
                    'delete'.tr(),
                    style: Constants.TEXT_STYLE6,
                  ),
                ],
              ),
            ),
          PopupMenuItem(
            height: 4,
            onTap: shareFunction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.share, color: MyColors.black),
                const SizedBox(width: 10),
                Text(
                  'share'.tr(),
                  style: Constants.TEXT_STYLE6,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            height: 4,
            onTap: reportFunction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bug_report_outlined, color: MyColors.black),
                const SizedBox(width: 10),
                Text(
                  'report'.tr(),
                  style: Constants.TEXT_STYLE6,
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
