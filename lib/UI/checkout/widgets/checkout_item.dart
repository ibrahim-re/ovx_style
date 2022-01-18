import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class checkoutItem extends StatelessWidget {
  const checkoutItem({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  final String text;
  final double value;
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
          Expanded(
            child: Text(
              text,
              style: Constants.TEXT_STYLE4.copyWith(fontWeight: FontWeight.w500, fontSize: 17),
            ),
          ),
          Text(
            '$value \$',
            style: Constants.PRICE_TEXT_STYLE,
          ),
        ],
      ),
    );
  }
}
