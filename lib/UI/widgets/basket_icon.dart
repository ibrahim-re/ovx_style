import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/UI/offers/offers_screen.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';

class BasketIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        NamedNavigatorImpl().push(
          NamedRoutes.Basket,
        );
      },
      icon: BlocBuilder<BasketBloc, BasketState>(
        builder: (ctx, state) {
          int basketItemsCount = context.read<BasketBloc>().basketItems.length;

          return iconBadge(
            child: SvgPicture.asset('assets/images/cart.svg'),
            badgeNumber: basketItemsCount,
          );
        },
      ),
    );
  }
}
