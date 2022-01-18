import 'dart:ui';

class BasketEvent {}

class AddItemToBasketEvent extends BasketEvent {
  String title;
  String imagePath;
  double price;
  Color color;
  String size;

  AddItemToBasketEvent(this.title, this.imagePath, this.size, this.price, this.color);
}

class RemoveItemFromBasketEvent extends BasketEvent {
  String id;

  RemoveItemFromBasketEvent(this.id);

}