import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';


class OfferTypeWidget extends StatelessWidget {
  final iconName;
  final title;
  final offerType;

  OfferTypeWidget(
      {required this.title,
        required this.iconName,
        required this.offerType,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //close bottom sheet
        NamedNavigatorImpl().pop();
        if(SharedPref.getUser().userType != UserType.Guest.toString())
          NamedNavigatorImpl().push(NamedRoutes.ADD_OFFER_SCREEN, arguments: {
            'offerType': offerType,
          });

        else
          EasyLoading.showToast('login to add'.tr());
      },
      highlightColor: MyColors.lightBlue,
      child: Column(
        children: [
          SvgPicture.asset('assets/images/$iconName.svg', fit: BoxFit.scaleDown,),
          const SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: Constants.TEXT_STYLE3,
          ),
        ],
      ),
    );
  }
}