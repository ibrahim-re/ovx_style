import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_states.dart';
import 'package:ovx_style/helper/payment_helper.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitialized());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if(event is InitializePayment){
      PaymentHelper.setupPayment(event.amount, event.userEmail, event.userName);
      yield PaymentInitialized();
    }else if(event is Pay){
      yield PaymentLoading();
      String result = await PaymentHelper.startPayment();
      if(result == 'Approved')
        yield PaymentSuccess();
      else if(result == 'Expired Card')
        yield PaymentFailed('Expired Card');
      else if(result == 'Response Received Too Late')
        yield PaymentFailed('Timed Out');
      else
        yield PaymentFailed('Failed To Pay');
    }
  }
}
