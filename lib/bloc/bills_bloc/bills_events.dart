
import 'package:ovx_style/model/basket.dart';

class BillsEvent {}

class FetchBills extends BillsEvent {}

class AddBills extends BillsEvent {
  List<BasketItem> basketItems;

  AddBills(this.basketItems);
}

class RequestBill extends BillsEvent {
  String userId;
  String billId;

  RequestBill(this.userId, this.billId);
}