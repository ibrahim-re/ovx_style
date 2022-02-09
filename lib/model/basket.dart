import 'dart:ui';

class BasketItem{
  String? id;
  String? productId;
  String? productOwnerId;
  String? imagePath;
  String? productName;
  double? price;
  Color? color;
  String? size;
  double? vat;
  double? shippingCost;
  String? shipTo;

  BasketItem({
    required this.id,
    required this.productId,
    required this.productOwnerId,
    required this.imagePath,
    required this.price,
    required this.productName,
    required this.color,
    required this.size,
    required this.vat,
    required this.shippingCost,
    required this.shipTo,
});
}