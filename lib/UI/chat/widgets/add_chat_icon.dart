import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class AddChatIcon extends StatelessWidget {
  //this index is to check which tap is now
  final int selectedIndex;

  AddChatIcon({required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //check if its group tap or chat tap
        if(selectedIndex == 2)
          ModalSheets().showCreateGroupSheet(context);
        else
          NamedNavigatorImpl().push(NamedRoutes.CREATE_CHAT_SCREEN);
      },
      icon: SvgPicture.asset('assets/images/add_chat.svg'),
    );
  }
}
