import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';

class CustomPopUpMenu extends StatelessWidget {
  final ownerId;
  final deleteFunction;

  CustomPopUpMenu({this.deleteFunction, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: MyColors.black,
      ),
      offset: Offset(-10, 40),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: MyColors.primaryColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      itemBuilder: (_) {
        return [
          if (ownerId == SharedPref.currentUser.id)
            PopupMenuItem(
              height: 4,
              onTap: deleteFunction ?? () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: MyColors.black),
                  const SizedBox(width: 10),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      color: MyColors.black,
                    ),
                  ),
                ],
              ),
            ),
        ];
      },
    );
  }
}
