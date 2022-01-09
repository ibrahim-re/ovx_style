import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class CircularAddButton extends StatelessWidget {
  final onPressed;

  CircularAddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(40, 50),
        primary: MyColors.secondaryColor,
        padding: const EdgeInsets.symmetric(vertical: 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Icon(
        Icons.add_circle,
      ),
    );
  }
}
