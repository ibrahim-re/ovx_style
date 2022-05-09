
import 'package:ovx_style/model/basket.dart';

class BasketHelper{

  //temp to hold shipping cost picked by user in order to add it to the basket
  static double tempShippingCost = 0;
  static String shipTo = '';

  //calculate basket total
  static double calculateTotal(List<BasketItem> basketItems){
    double total = 0;

    basketItems.forEach((item) {
      total += item.price!;
    });

    return double.parse(total.toStringAsFixed(2));
  }

  //calculate VAT total
  static double calculateTotalVAT(List<BasketItem> basketItems){
    double total = 0;

    basketItems.forEach((item) {
      if(item.vat != 0)
        total += calculateVAT(item.price!, item.vat!);

    });

    return double.parse(total.toStringAsFixed(2));
  }

  //calculate VAT for each item
  static double calculateVAT(double price, double vat){
    double amount = 0;

    amount = (price * vat) / 100;

    return amount;
  }

  //calculate basket total
  static double calculateTotalShippingCost(List<BasketItem> basketItems){
    double total = 0;

    /* this list is to help calculate shipping costs only once
    when same product added multiple times */
    List<String> calculatedProductIds = [];

    basketItems.forEach((item) {

      print('cost ${item.shippingCost} ${item.productName}');
      if(!calculatedProductIds.contains(item.productId!)){
        calculatedProductIds.add(item.productId!);
        total += item.shippingCost!;
      }

    });

    return double.parse(total.toStringAsFixed(2));
  }


}