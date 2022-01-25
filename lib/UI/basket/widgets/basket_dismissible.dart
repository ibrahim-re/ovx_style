import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/model/basket.dart';

class basketDismissible extends StatelessWidget {
  const basketDismissible({
    Key? key,
    required this.basketItem,
  }) : super(key: key);

  final BasketItem basketItem;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        color: MyColors.red,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SvgPicture.asset(
              'assets/images/trash.svg',
              color: MyColors.primaryColor,
          ),
        ),
      ),
      key: ValueKey(basketItem.title! + DateTime.now().toString()),
      onDismissed: (_) {
        context.read<BasketBloc>().add(RemoveItemFromBasketEvent(basketItem.id!));
      },
      child: ListTile(
        leading: Container(
          width: screenWidth * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              basketItem.imagePath!,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        title: Text(
          basketItem.title!,
          style: Constants.TEXT_STYLE6.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: basketItem.color!,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              basketItem.size!,
              style: Constants.TEXT_STYLE1.copyWith(fontSize: 14),
            ),
          ],
        ),
        trailing: Text(
          '${basketItem.price} ${SharedPref.getCurrency()}',
          style: Constants.PRICE_TEXT_STYLE,
        ),
      ),
    );
  }
}
