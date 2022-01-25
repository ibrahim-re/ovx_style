
class PaymentEvent {}

class InitializePayment extends PaymentEvent {
  double amount;
  String userEmail;
  String userName;

  InitializePayment(this.amount, this.userEmail, this.userName);
}

class Pay extends PaymentEvent{}