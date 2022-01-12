import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/product_property.dart';

class PropertiesSection extends StatefulWidget {
  const PropertiesSection(
      {Key? key, required this.offerProperties, required this.discount})
      : super(key: key);

  final List<ProductProperty> offerProperties;
  final double discount;

  @override
  State<PropertiesSection> createState() => _PropertiesSectionState();
}

class _PropertiesSectionState extends State<PropertiesSection> {
  int selectedPropertyIndex = 0;
  int selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final properties = widget.offerProperties;
    final sizes = widget.offerProperties[selectedPropertyIndex].sizes;
    final currentItemPrice = properties[selectedPropertyIndex].sizes![selectedSizeIndex].price;

    return Column(
      children: [
        widget.discount == 0
            ? Align(
                alignment: Alignment.centerRight,
                child: Text('$currentItemPrice \$',
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.secondaryColor,
                    )),
              )
            : Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$currentItemPrice \$',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${Helper().priceAfterDiscount(currentItemPrice!, widget.discount)} \$',
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                'colors'.tr(),
                style: Constants.TEXT_STYLE8,
              ),
              Spacer(),
              Wrap(
                direction: Axis.horizontal,
                children: properties
                    .map(
                      (property) => Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          border: selectedPropertyIndex ==
                                  properties.indexOf(property)
                              ? Border.all(
                                  color: Colors.grey.shade500,
                                  style: BorderStyle.solid)
                              : null,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => selectedPropertyIndex =
                                properties.indexOf(property));
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: property.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            children: [
              Text(
                'sizes'.tr(),
                style: Constants.TEXT_STYLE8,
              ),
              Spacer(),
              Wrap(
                direction: Axis.horizontal,
                children: sizes!
                    .map(
                      (size) => GestureDetector(
                        onTap: () {
                          setState(
                              () => selectedSizeIndex = sizes.indexOf(size));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selectedSizeIndex == sizes.indexOf(size)
                                ? MyColors.secondaryColor
                                : MyColors.lightBlue.withOpacity(0.2),
                          ),
                          child: Text(size.size!,
                              style: TextStyle(
                                color: selectedSizeIndex == sizes.indexOf(size)
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // Icon(
              //   Icons.info,
              //   color: Colors.yellow,
              // )
            ],
          ),
        ),
      ],
    );
  }
}
