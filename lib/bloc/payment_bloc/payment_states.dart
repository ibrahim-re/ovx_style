
class PaymentState {}

class PaymentInitialized extends PaymentState{}

class PaymentSuccess extends PaymentState{}

class PaymentLoading extends PaymentState{}

class PaymentFailed extends PaymentState{
  String message;

  PaymentFailed(this.message);

}