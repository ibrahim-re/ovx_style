import 'package:flutter/material.dart';

class shipToSection extends StatefulWidget {
  const shipToSection({Key? key}) : super(key: key);

  @override
  State<shipToSection> createState() => _shipToSectionState();
}

class _shipToSectionState extends State<shipToSection> {
  int selectedIndex = 0;
  Widget CountruItemBuilder({
    required Color clr,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        border: selectedIndex == index
            ? Border.all(color: Colors.grey.shade500, style: BorderStyle.solid)
            : null,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: clr,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            'Ship to',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          CountruItemBuilder(clr: Colors.red, index: 0),
          CountruItemBuilder(clr: Colors.green, index: 1),
          CountruItemBuilder(clr: Colors.black, index: 2),
          CountruItemBuilder(clr: Colors.blue, index: 3),
        ],
      ),
    );
  }
}
