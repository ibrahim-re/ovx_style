import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:ovx_style/helper/payment_helper.dart';
import 'package:ovx_style/model/bill.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  BillsBloc() : super(BillsInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  List<Bill> myBills = [];

  double calculateTotalBillsAmount() {
    double total = 0;

    myBills.forEach((bill) {
      if (!bill.isRequested!) total += bill.amount;
    });

    return double.parse(total.toStringAsFixed(2));
  }

  @override
  Stream<BillsState> mapEventToState(BillsEvent event) async* {
    if (event is AddBills) {
      yield AddBillsLoading();

      print('staaaaaaaaaaaart');
      try {

        PaymentHelper.generateAndSendBills(
          event.basketItems,
          SharedPref.getUser().id!,
          event.buyerName,
          event.buyerEmail,
          event.buyerPhoneNumber,
          event.buyerCountry,
          event.buyerCity,
          event.latitude,
          event.longitude,
        );

        yield AddBillsSucceed();
      } catch (e) {
        print('error bills $e');
        yield AddBillsFailed();
      }
    } else if (event is FetchBills) {
      yield FetchBillsLoading();
      try {
        myBills =
            await _databaseRepositoryImpl.fetchBills(SharedPref.getUser().id!);
        yield FetchBillsSucceed(myBills);
      } catch (e) {
        yield FetchBillsFailed('error occurred'.tr());
      }
    } else if (event is RequestBill) {
      yield BillRequestLoading();
      _databaseRepositoryImpl.requestBill(event.userId, event.billId);
      try {
        yield BillRequested();
      } catch (e) {
        yield BillRequestFailed('');
      }
    }
  }
}
