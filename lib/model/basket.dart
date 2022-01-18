import 'dart:ui';

class BasketItem{
  String? id;
  String? imagePath;
  String? title;
  double? price;
  Color? color;
  String? size;

  BasketItem({
    required this.id,
    required this.imagePath,
    required this.price,
    required this.title,
    required this.color,
    required this.size
});

}