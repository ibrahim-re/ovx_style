import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class sizesSection extends StatefulWidget {
  const sizesSection({Key? key}) : super(key: key);

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
    }) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Text(
            'Sizes',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Spacer(),
          sizeBuilder(text: 'Big', index: 0),
          sizeBuilder(text: 'Medium', index: 1),
          sizeBuilder(text: 'Small', index: 2),
          Icon(
            Icons.info,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }
}
