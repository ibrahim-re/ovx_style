import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VATSwitch extends StatefulWidget {
  @override
  _VATSwitchState createState() => _VATSwitchState();
}

class _VATSwitchState extends State<VATSwitch> {
  bool includeVAT = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: SvgPicture.asset('assets/images/discount.svg', fit: BoxFit.scaleDown,),
          title: Text(
            'include vat'.tr(),
            style: Constants.TEXT_STYLE4,
          ),
          trailing: Switch.adaptive(
              value: includeVAT,
              activeColor: MyColors.secondaryColor,
              inactiveThumbColor: MyColors.grey,
              inactiveTrackColor: MyColors.lightGrey,
              onChanged: (newValue) {
                setState(() {
                  includeVAT = newValue;
                });
              }),
        ),
        if (includeVAT)
          CustomTextFormField(
            hint: '${'include vat'.tr()}  %',
            keyboardType: TextInputType.number,
            validateInput: (_) {},
            saveInput: (_) {},
            onChanged: (value){
              context.read<AddOfferBloc>().updateVAT(double.tryParse(value) ?? 0);
            },
          ),
      ],
    );
  }
}
