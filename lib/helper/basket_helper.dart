
import 'package:ovx_style/model/basket.dart';

class BasketHelper{

  static double calculateTotal(List<BasketItem> basketItems){
    double total = 0;

    basketItems.forEach((item) {
      total += item.price!;
    });

    return total;
  }


}