import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_bloc.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_events.dart';
import 'package:ovx_style/bloc/gifts_bloc/gifts_states.dart';
import 'package:provider/src/provider.dart';

class GiftItem extends StatefulWidget {
  @override
  _GiftItemState createState() => _GiftItemState();
}

class _GiftItemState extends State<GiftItem> {
  @override
  void initState() {
    context.read<GiftsBloc>().add(FetchGifts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          NamedNavigatorImpl().push(NamedRoutes.MY_GIFTS_SCREEN);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                'gifts'.tr(),
                style: Constants.TEXT_STYLE6,
              ),
            ),
            Expanded(
              child: BlocBuilder<GiftsBloc, GiftsState>(
                builder: (context, state) {
                  if (state is FetchGiftsLoading) {
                    return Center(
                      child: RefreshProgressIndicator(
                        //color: MyColors.secondaryColor,
                      ),
                    );
                  } else if (state is FetchGiftsFailed)
                    return Center(
                      child: Text('0'),
                    );
                  else {
                    int total = context.read<GiftsBloc>().myGifts.length;
                    return Text(
                      '$total',
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}