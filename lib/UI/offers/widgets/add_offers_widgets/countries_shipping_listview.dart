import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:provider/src/provider.dart';

class CountriesShippingListView extends StatefulWidget {
  @override
  _CountriesShippingListViewState createState() =>
      _CountriesShippingListViewState();
}

class _CountriesShippingListViewState extends State<CountriesShippingListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: context.read<AddOfferBloc>().shippingCosts.length + 1,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.lightBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        index <context.read<AddOfferBloc>().shippingCosts.length ? context.read<AddOfferBloc>().shippingCosts.keys.toList()[index]
                            : '${SharedPref.getUser().countryFlag} ${SharedPref.getUser().country}',
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: Constants.TEXT_STYLE1
                            .copyWith(color: MyColors.secondaryColor),
                      ),
                    ),
                    Text(
                      index < context.read<AddOfferBloc>().shippingCosts.length ? context.read<AddOfferBloc>().shippingCosts.values
                              .toList()[index]
                              .toString() +
                          ' ${SharedPref.getCurrency()}'
                      : '0.0 ${SharedPref.getCurrency()}',
                      style: Constants.TEXT_STYLE1
                          .copyWith(color: MyColors.secondaryColor),
                    ),
                  ],
                ),
              ),
            ),
            HorizontalSpaceWidget(widthPercentage: 0.02),
            //unable delete for user own country, which has index 0
            if (index < context.read<AddOfferBloc>().shippingCosts.length)
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      context.read<AddOfferBloc>().removeFromShippingCosts(
                          context.read<AddOfferBloc>().shippingCosts.keys.toList()[index]
                      );
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/images/trash.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
