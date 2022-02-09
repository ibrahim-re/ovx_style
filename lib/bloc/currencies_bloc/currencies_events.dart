
class CurrencyEvent {}

class GetCurrencies extends CurrencyEvent {}

class ChangeCurrency extends CurrencyEvent {
  String currencyCode;

  ChangeCurrency(this.currencyCode);
}