import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/model/product_property.dart';

class sizesSection extends StatefulWidget {
  const sizesSection({Key? key, required this.Sizes}) : super(key: key);

  final List<ProductSize> Sizes;
  @override
  State<sizesSection> createState() => _sizesSectionState();
}

class _sizesSectionState extends State<sizesSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget sizeBuilder({
      required String text,
      required int index,
      required double price,
    }) {
      return GestureDetector(
        onTap: () {
          EasyLoading.showInfo(
            'Price for this size = $price',
            dismissOnTap: true,
            duration: Duration(seconds: 3),
          );
          setState(() => selectedIndex = index);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedIndex == index
                ? MyColors.secondaryColor
                : MyColors.lightBlue.withOpacity(0.2),
          ),
          child: Text(text,
              style: TextStyle(
                color: selectedIndex == index ? Colors.white : Colors.black,
              )),
        ),
      );
    }

    int x = 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Text(
            'Sizes',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Spacer(),
          Row(
            children: widget.Sizes.map((size) {
              return sizeBuilder(
                text: size.size!,
                price: size.price!,
                index: x++,
              );
            }).toList(),
          ),
          Icon(
            Icons.info,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }
}
