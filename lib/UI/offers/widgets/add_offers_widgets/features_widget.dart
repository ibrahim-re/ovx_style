import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';

class FeaturesWidget extends StatefulWidget {
  @override
  _FeaturesWidgetState createState() => _FeaturesWidgetState();
}

class _FeaturesWidgetState extends State<FeaturesWidget> {
  bool isReturnAvailable = false;
  bool isShippingFree = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'features'.tr(),
          style: Constants.TEXT_STYLE4,
        ),
        ListTile(
          leading: SvgPicture.asset('assets/images/return.svg', fit: BoxFit.scaleDown,),
          title: Text(
            'return products'.tr(),
            style: Constants.TEXT_STYLE3,
          ),
          trailing: Checkbox(
              value: isReturnAvailable,
              onChanged: (newVal) {
                context.read<AddOfferBloc>().updateIsReturned(newVal?? false);
                setState(() {
                  isReturnAvailable = newVal ?? false;
                });
              },
            activeColor: MyColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        VerticalSpaceWidget(
          heightPercentage: 0.015,
        ),
        ListTile(
          leading: SvgPicture.asset('assets/images/free.svg', fit: BoxFit.scaleDown,),
          title: Text(
            'free shipping'.tr(),
            style: Constants.TEXT_STYLE3,
          ),
          trailing: Checkbox(
            value: isShippingFree,
            onChanged: (newVal) {
              context.read<AddOfferBloc>().updateIsFreeShipping(newVal?? false);
              setState(
                () {
                  isShippingFree = newVal ?? false;
                },
              );
            },
            activeColor: MyColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
