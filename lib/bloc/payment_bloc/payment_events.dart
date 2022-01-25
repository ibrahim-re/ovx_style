
class PaymentEvent {}

class InitializePayment extends PaymentEvent {
  double amount;
  String userEmail;
  String userName;
  String currency;

  InitializePayment(this.amount, this.userEmail, this.userName, this.currency);
}

class Pay extends PaymentEvent{}