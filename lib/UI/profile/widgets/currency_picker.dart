import 'package:currency_picker/currency_picker.dart' as picker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_bloc.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_events.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_states.dart';
import 'package:provider/src/provider.dart';

class CurrencyPicker extends StatefulWidget {
  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  @override
  void initState() {
    context.read<CurrencyBloc>().add(GetCurrencies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state is GetCurrenciesLoading)
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  color: MyColors.secondaryColor,
                ),
              ),
            ),
          );
        else if (state is GetCurrenciesSucceed)
          return TextButton(
            onPressed: () {
              picker.showCurrencyPicker(
                context: context,
                currencyFilter: state.currencies + ['USD'],
                onSelect: (currency) async {
                  //update shared pref and the value that holds it
                  SharedPref.setCurrency(currency.code);
                  setState(() {});

                  //clear basket to add again with new prices
                  context.read<BasketBloc>().add(ClearBasket());
                },
                theme: picker.CurrencyPickerThemeData(
                  titleTextStyle: Constants.TEXT_STYLE4,
                  subtitleTextStyle: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
                ),
              );
            },
            child: Text(
              '${SharedPref.getCurrency()}',
              style: TextStyle(
                color: MyColors.secondaryColor,
              ),
            ),
          );

        else
          return Container();
      },
    );
  }
}
