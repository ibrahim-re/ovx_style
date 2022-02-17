import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class CustomRedirectWidget extends StatelessWidget {
  final title;
  final iconName;

  CustomRedirectWidget({@required this.iconName, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.lightGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: Constants.TEXT_STYLE1,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        leading: SvgPicture.asset('assets/images/$iconName.svg', fit: BoxFit.scaleDown,),
      ),
    );
  }
}
