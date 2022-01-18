import 'dart:ui';

class BasketItem{
  String? id;
  String? productId;
  String? imagePath;
  String? title;
  double? price;
  Color? color;
  String? size;
  double? vat;
  double? shippingCost;
  String? shipTo;

  BasketItem({
    required this.id,
    required this.productId,
    required this.imagePath,
    required this.price,
    required this.title,
    required this.color,
    required this.size,
    required this.vat,
    required this.shippingCost,
    required this.shipTo,
});
}