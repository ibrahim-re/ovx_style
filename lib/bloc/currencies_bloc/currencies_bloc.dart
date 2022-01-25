import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_events.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_states.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrenciesInitialized());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();

  @override
  Stream<CurrencyState> mapEventToState(CurrencyEvent event) async* {
    if(event is GetCurrencies){
      try {
        yield GetCurrenciesLoading();

        Map<String, double> currencies = await offersRepositoryImpl.getCurrencies();
        SharedPref.setCurrencies(currencies);

        yield GetCurrenciesSucceed(currencies.keys.toList());
      } catch (e) {
        yield GetCurrenciesFailed('error occurred'.tr());
      }

    }
  }

}
