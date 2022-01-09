import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';


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
        NamedNavigatorImpl().pop();
        NamedNavigatorImpl().push(NamedRoutes.ADD_OFFER_SCREEN, arguments: {
          'offerType': offerType,
        });
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