import 'package:flutter/material.dart';

class colorSection extends StatefulWidget {
  const colorSection({Key? key}) : super(key: key);

  @override
  State<colorSection> createState() => _colorSectionState();
}

int selectedIndex = 0;

class _colorSectionState extends State<colorSection> {
  Widget CircleBuilder({
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            'Colors',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          Spacer(),
          CircleBuilder(clr: Colors.lightBlueAccent.withOpacity(0.3), index: 0),
          CircleBuilder(clr: Colors.black.withOpacity(.3), index: 1),
          CircleBuilder(clr: Colors.lightGreen.withOpacity(.3), index: 2),
          CircleBuilder(clr: Colors.red.withOpacity(.3), index: 3),
        ],
      ),
    );
  }
}
