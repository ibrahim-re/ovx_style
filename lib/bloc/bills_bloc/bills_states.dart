
import 'package:ovx_style/model/bill.dart';

class BillsState {}

class BillsInitialized extends BillsState {}

class FetchBillsLoading extends BillsState {}

class FetchBillsSucceed extends BillsState {
  List<Bill> myBills;

  FetchBillsSucceed(this.myBills);
}

class FetchBillsFailed extends BillsState {
  String message;

  FetchBillsFailed(this.message);
}

class AddBillsLoading extends BillsState {}

class AddBillsSucceed extends BillsState {}

class AddBillsFailed extends BillsState {}

class BillRequestLoading extends BillsState {}

class BillRequested extends BillsState {}

class BillRequestFailed extends BillsState {
  String message;

  BillRequestFailed(this.message);
}
