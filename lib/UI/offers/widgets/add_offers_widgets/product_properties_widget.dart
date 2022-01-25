import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPropertiesWidget extends StatefulWidget {
  @override
  State<ProductPropertiesWidget> createState() =>
      _ProductPropertiesWidgetState();
}

class _ProductPropertiesWidgetState extends State<ProductPropertiesWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${'properties'.tr()}  *",
              style: Constants.TEXT_STYLE4,
            ),
            TextButton.icon(
              onPressed: () async {
                //wait for adding sizes to end and update th ui to show them
                await NamedNavigatorImpl()
                    .push(NamedRoutes.ADD_PROPERTIES_SCREEN);
                setState(() {});
              },
              icon: Icon(
                Icons.add,
                color: MyColors.secondaryColor,
              ),
              label: Text(
                'add'.tr(),
                style: Constants.TEXT_STYLE4.copyWith(
                  color: MyColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: context.read<AddOfferBloc>().properties.length,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.lightBlue.withOpacity(0.3),
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('color'.tr()),
                    CircleAvatar(
                      backgroundColor: context.read<AddOfferBloc>().properties[index].color,
                      radius: 14,
                    ),
                  ],
                ),
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: context.read<AddOfferBloc>().properties[index].sizes!.map((e) {
                    return Chip(
                      backgroundColor: MyColors.lightBlue.withOpacity(0.5),
                      label: Text('${e.size ?? ''} - ${e.price ?? 0} ${SharedPref.getCurrency()}'),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        context.read<AddOfferBloc>().properties.removeAt(index);
                      });
                    },
                    child: SvgPicture.asset('assets/images/trash.svg', fit: BoxFit.scaleDown,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
