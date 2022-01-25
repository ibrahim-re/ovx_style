import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/basket/widgets/basket_dismissible.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';
import 'package:ovx_style/helper/basket_helper.dart';
import 'package:ovx_style/model/basket.dart';

class BasketScreen extends StatelessWidget {
  final navigator;

  BasketScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //get basket items and calculate total
    List<BasketItem> basket = context.read<BasketBloc>().basketItems;
    double basketTotal = BasketHelper.calculateTotal(basket);
    double vatTotal = BasketHelper.calculateTotalVAT(basket);
    double shippingCostTotal = BasketHelper.calculateTotalShippingCost(basket);

    return Scaffold(
      appBar: AppBar(
        title: Text('basket'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'products'.tr(),
              style:
                  Constants.TEXT_STYLE8.copyWith(fontWeight: FontWeight.w500),
            ),
            if (basket.isEmpty)
              Expanded(
                child: NoDataWidget(
                  text: 'empty cart'.tr(),
                  iconName: 'cart',
                ),
              )
            else
              Expanded(
                child: BlocBuilder<BasketBloc, BasketState>(
                  builder: (context, state) => ListView.builder(
                    itemBuilder: (_, index) => basketDismissible(
                      basketItem: basket[index],
                    ),
                    itemCount: basket.length,
                  ),
                ),
              ),
            Divider(
              color: MyColors.grey.withOpacity(0.3),
              thickness: 2,
            ),
            VerticalSpaceWidget(heightPercentage: 0.02),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColors.lightGrey.withOpacity(0.8),
              ),
              child: Row(
                children: [
                  Text(
                    'total'.tr(),
                    style: Constants.TEXT_STYLE8.copyWith(fontSize: 20),
                  ),
                  Spacer(),
                  BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {

                    //listen to basket changes and rebuild total widget
                    basketTotal = BasketHelper.calculateTotal(basket);
                    vatTotal = BasketHelper.calculateTotalVAT(basket);
                    shippingCostTotal = BasketHelper.calculateTotalShippingCost(basket);

                    return Text(
                        '$basketTotal ${SharedPref.getCurrency()}',
                        style: Constants.PRICE_TEXT_STYLE,
                      );
                  }),
                ],
              ),
            ),
            VerticalSpaceWidget(heightPercentage: 0.02),

            //bloc builder used to listen to basket length
            BlocBuilder<BasketBloc, BasketState>(
              builder: (context, state) => CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'checkout'.tr(),
                function: basket.isEmpty
                    ? null
                    : () {
                        NamedNavigatorImpl()
                            .push(NamedRoutes.CheckOut, arguments: {
                          'total': basketTotal,
                          'vat': vatTotal,
                          'shipping cost': shippingCostTotal,
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
