import 'dart:ui' show Color;

class ProductProperty{
  Color? color;
  List<ProductSize>? sizes;

  ProductProperty({
    required this.color,
    required this.sizes,
});

  Map<String, dynamic> toMap() => {
    'color': color!.value,
    'sizes': sizes!.map((e) => e.toMap()).toList(),
  };

}


class ProductSize{
  String? size;
  double? price;

  ProductSize({
    required this.size,
    required this.price,
});

  Map<String, dynamic> toMap() => {
    'size': size,
    'price': price,
  };

}