
class CurrencyState {}

class CurrenciesInitialized extends CurrencyState {}

class GetCurrenciesLoading extends CurrencyState {}

class GetCurrenciesSucceed extends CurrencyState {}

class GetCurrenciesFailed extends CurrencyState {
  String message;

  GetCurrenciesFailed(this.message);
}

class CurrencyChanged extends CurrencyState {}