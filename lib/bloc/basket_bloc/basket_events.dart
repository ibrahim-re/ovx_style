import 'dart:ui';

class BasketEvent {}

class AddItemToBasketEvent extends BasketEvent {
  String productId;
  String productOwnerId;
  String title;
  String imagePath;
  double price;
  Color color;
  String size;
  double vat;
  double shippingCost;
  String shipTo;

  AddItemToBasketEvent(this.productId, this.productOwnerId, this.title, this.imagePath, this.size, this.price,
      this.color, this.vat, this.shippingCost,
      this.shipTo);
}

class RemoveItemFromBasketEvent extends BasketEvent {
  String id;

  RemoveItemFromBasketEvent(this.id);
}

class ClearBasket extends BasketEvent {}
