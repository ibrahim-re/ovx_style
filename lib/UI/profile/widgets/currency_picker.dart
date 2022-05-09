import 'package:currency_picker/currency_picker.dart' as picker;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/settings.dart';
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
        else if (state is GetCurrenciesFailed)
          return Center();
        else {
          Map<String, double> currencies = context.read<CurrencyBloc>().currencies;
          // return TextButton(
          //   onPressed: () {
          //     picker.showCurrencyPicker(
          //       context: context,
          //       currencyFilter: currencies.keys.toList() + ['USD'],
          //       onSelect: (currency) async {
          //         context.read<CurrencyBloc>().add(ChangeCurrency(currency.code));
          //         setState(() {});
          //
          //         //clear basket to add again with new prices
          //         context.read<BasketBloc>().add(ClearBasket());
          //       },
          //       theme: picker.CurrencyPickerThemeData(
          //         titleTextStyle: Constants.TEXT_STYLE4,
          //         subtitleTextStyle: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
          //       ),
          //     );
          //   },
          //   child: Text(
          //     '${SharedPref.getCurrency()}',
          //     style: TextStyle(
          //       color: MyColors.secondaryColor,
          //     ),
          //   ),
          // );
          return SettingsItemBuilder(
            icon: '',
            text: 'currency'.tr() + ': ${SharedPref.getCurrency()}',
            toDo: () {
              picker.showCurrencyPicker(
                context: context,
                currencyFilter: currencies.keys.toList() + ['USD'],
                onSelect: (currency) async {
                  context
                      .read<CurrencyBloc>()
                      .add(ChangeCurrency(currency.code));
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
          );
        }
      },
    );
  }
}
