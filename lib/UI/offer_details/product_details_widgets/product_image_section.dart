import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/product_property.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({
    Key? key,
    required this.productImages,
    required this.description,
    required this.categories,
    required this.status,
    required this.properties,
  }) : super(key: key);

  final List<String> productImages, categories;
  final String description, status;
  final List<ProductProperty> properties;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          child: ScrollSnapList(
            itemSize: MediaQuery.of(context).size.height / 3,
            dynamicItemSize: true,
            itemBuilder: (ctx, index) => Image.network(productImages[index], width: MediaQuery.of(context).size.height / 3),
            onItemFocus: (int) {},
            itemCount: productImages.length,
          ),
        ),
        // if (productImages.length == 1)
        //   Container(
        //     width: double.infinity,
        //     height: MediaQuery.of(context).size.height / 3,
        //     child: Center(
        //       child: Image.network(productImages.first),
        //     ),
        //   )
        // else
        //   Container(
        //     width: double.infinity,
        //     height: MediaQuery.of(context).size.height / 3,
        //     child: ListView.separated(
        //       scrollDirection: Axis.horizontal,
        //       padding: const EdgeInsets.all(6),
        //       itemBuilder: (context, index) => Image(
        //         image: NetworkImage(productImages[index]),
        //         fit: BoxFit.cover,
        //       ),
        //       separatorBuilder: (context, index) => const SizedBox(width: 6),
        //       itemCount: productImages.length,
        //     ),
        //   ),
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
                  status == OfferStatus.New.toString()
                      ? "new".tr()
                      : "Used".tr(),
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
            //spacing: 4,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: categories.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: Constants.TEXT_STYLE7,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: MyColors.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            description,
            style: Constants.TEXT_STYLE4,
          ),
        ),
      ],
    );
  }
}
