import 'dart:ui';

class BasketEvent {}

class AddItemToBasketEvent extends BasketEvent {
  String title;
  double price;
  Color color;
  String size;

  AddItemToBasketEvent(this.title, this.size, this.price, this.color);
}

class RemoveItemFromBasketEvent extends BasketEvent {

}