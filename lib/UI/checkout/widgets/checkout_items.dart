import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class checkoutItem extends StatelessWidget {
  const checkoutItem({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  final String text, value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyColors.secondaryColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          Text(
            value + ' \$',
            style: TextStyle(
              color: MyColors.secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
