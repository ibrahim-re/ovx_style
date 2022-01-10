import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/product_property.dart';

class imageSection extends StatelessWidget {
  const imageSection({
    Key? key,
    required this.productImages,
    required this.descreption,
    required this.categories,
    required this.status,
    required this.discount,
    required this.proberties,
  }) : super(key: key);

  final List<String> productImages, categories;
  final String descreption, status;
  final double discount;
  final List<ProductProperty> proberties;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(6),
            itemBuilder: (context, index) => Image(
              image: NetworkImage(productImages[index]),
              fit: BoxFit.cover,
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 6),
            itemCount: productImages.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  status == OfferStatus.New ? "New" : "Used",
                  style: TextStyle(color: MyColors.primaryColor),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: MyColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Wrap(
            spacing: 4,
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: categories.map((item) {
              return Text(
                item,
                style: TextStyle(color: MyColors.lightBlue),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                descreption,
                style: TextStyle(fontSize: 20),
              )),
              discount == 0
                  ? Text('${proberties.first.sizes!.first.price} \$',
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.secondaryColor,
                      ))
                  : Row(
                      children: [
                        Text(
                          '${proberties.first.sizes!.first.price} \$',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${Helper().priceAfterDiscount(proberties.first.sizes!.first.price!, discount)} \$',
                          style: TextStyle(
                            fontSize: 18,
                            color: MyColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
