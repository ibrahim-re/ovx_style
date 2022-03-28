import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/add_offers_widgets/categories_widget.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class FiltersWidget extends StatefulWidget {
  final UserType userType;

  FiltersWidget({required this.userType});
  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  Map<String, OfferType> iconNames = {
    'product': OfferType.Product,
    'video': OfferType.Video,
    'image': OfferType.Image,
    'post': OfferType.Post,
  };

  List<String> showOnly = [];
  RangeValues val = RangeValues(0, 10000);

  void _updateShowOnly(String offerType) {
    if (!showOnly.contains(offerType))
      showOnly.add(offerType);
    else
      showOnly.remove(offerType);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Center(
            child: Text(
              'filter'.tr(),
              style: Constants.TEXT_STYLE2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5),
            ),
          ),
          Wrap(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'show only'.tr(),
                style: Constants.TEXT_STYLE2.copyWith(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: iconNames.keys
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          _updateShowOnly(iconNames[item].toString());

                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: showOnly.contains(iconNames[item].toString())
                                      ? MyColors.lightGrey
                                      : MyColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/$item.svg',
                                  fit: BoxFit.scaleDown,
                                )),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              item.tr(),
                              style:
                                  Constants.TEXT_STYLE3.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 100,
              ),
              if (showOnly.contains(OfferType.Product.toString()))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'price'.tr(),
                      style: Constants.TEXT_STYLE4,
                    ),
                    RangeSlider(
                      labels: RangeLabels(val.start.ceil().toString(), val.end.ceil().toString()),
                      divisions: 10000,
                      activeColor: MyColors.secondaryColor,
                      inactiveColor: MyColors.lightGrey,
                      min: 0,
                      max: 10000,
                      values: val,
                      onChanged: (rangeValues) {
                        setState(() {
                          val = rangeValues;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CategoriesWidget(whereToUse: 'Filter',),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              Center(
                child: Container(
                  width: 200,
                  child: CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'apply'.tr(),
                    function: () {
                      context.read<OfferBloc>().add(GetFilteredOffers(val.start, val.end, OfferHelper.categories, showOnly, widget.userType));
                      NamedNavigatorImpl().pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return Container();
  }
}
