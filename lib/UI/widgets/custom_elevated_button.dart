import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';


class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final String text;
  final function;

  const CustomElevatedButton({Key? key,
    required this.color,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: 10,
        shadowColor: MyColors.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
