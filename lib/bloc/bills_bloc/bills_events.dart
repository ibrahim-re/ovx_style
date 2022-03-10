import 'package:ovx_style/model/basket.dart';

class BillsEvent {}

class FetchBills extends BillsEvent {}

class AddBills extends BillsEvent {
    List<BasketItem> basketItems;
    String buyerName, buyerEmail, buyerPhoneNumber, buyerCity, buyerCountry;
    double latitude, longitude;

    AddBills(
        this.basketItems,
        this.buyerName,
        this.buyerEmail,
        this.buyerPhoneNumber,
        this.buyerCountry,
        this.buyerCity,
        this.latitude,
        this.longitude,
        );
}

class RequestBill extends BillsEvent {
    String userId;
    String billId;

    RequestBill(this.userId, this.billId);
}
