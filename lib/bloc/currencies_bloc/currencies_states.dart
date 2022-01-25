
class CurrencyState {}

class CurrenciesInitialized extends CurrencyState {}

class GetCurrenciesLoading extends CurrencyState {}

class GetCurrenciesSucceed extends CurrencyState {
  List<String> currencies;

  GetCurrenciesSucceed(this.currencies);
}

class GetCurrenciesFailed extends CurrencyState {
  String message;

  GetCurrenciesFailed(this.message);
}