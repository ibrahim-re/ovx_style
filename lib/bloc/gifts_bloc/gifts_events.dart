
import 'package:ovx_style/model/basket.dart';
import 'package:ovx_style/model/user.dart';

class GiftsEvent {}

class FetchGifts extends GiftsEvent {}

class SendGift extends GiftsEvent {
  List<BasketItem> basketItems;
  User user;

  SendGift(
      this.basketItems,
      this.user,
      );
}
