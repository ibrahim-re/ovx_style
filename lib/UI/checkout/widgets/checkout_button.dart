import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';

class checkoutButton extends StatelessWidget {
  const checkoutButton({
    Key? key,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  final String text;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap(),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.secondaryColor),
          borderRadius: BorderRadius.circular(15),
          color:
              text == 'Pay' ? MyColors.secondaryColor : MyColors.primaryColor,
        ),
        child: text == 'Pay'
            ? Text(
                text.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.primaryColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_giftcard_outlined,
                    color: MyColors.secondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: MyColors.secondaryColor,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
