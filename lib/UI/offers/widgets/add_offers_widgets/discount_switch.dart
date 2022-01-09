import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'discount_date.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountSwitch extends StatefulWidget {
  @override
  _DiscountSwitchState createState() => _DiscountSwitchState();
}

class _DiscountSwitchState extends State<DiscountSwitch> {
  bool includeDiscount = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: SvgPicture.asset('assets/images/discount.svg', fit: BoxFit.scaleDown,),
          title: Text(
            'discount'.tr(),
            style: Constants.TEXT_STYLE4,
          ),
          trailing: Switch.adaptive(
              value: includeDiscount,
              activeColor: MyColors.secondaryColor,
              inactiveThumbColor: MyColors.grey,
              inactiveTrackColor: MyColors.lightGrey,
              onChanged: (newValue) {
                setState(() {
                  includeDiscount = newValue;
                });
              }),
        ),
        if (includeDiscount)
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hint: 'discount'.tr(),
                  keyboardType: TextInputType.number,
                  validateInput: (_) {},
                  saveInput: (_) {},
                  onChanged: (value){
                    context.read<AddOfferBloc>().updateDiscount(double.tryParse(value)?? 0);
                  },
                ),
              ),
              HorizontalSpaceWidget(
                widthPercentage: 0.015,
              ),
              Expanded(
                child: DiscountDate(),
              ),
            ],
          ),
      ],
    );
  }
}
