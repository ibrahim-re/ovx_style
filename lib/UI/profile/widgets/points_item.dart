import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/bloc/points_bloc/points_bloc.dart';
import 'package:ovx_style/bloc/points_bloc/points_events.dart';
import 'package:ovx_style/bloc/points_bloc/points_states.dart';
import 'package:provider/src/provider.dart';

class PointsItem extends StatefulWidget {
  @override
  State<PointsItem> createState() => _PointsItemState();
}

class _PointsItemState extends State<PointsItem> {

  @override
  void initState() {
    context.read<PointsBloc>().add(GetPoints());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          ModalSheets().showBuyPointsSheet(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                'points'.tr(),
                style: Constants.TEXT_STYLE6,
              ),
            ),
            Expanded(
              child: BlocBuilder<PointsBloc, PointsState>(
                builder: (context, state) {
                  if (state is GetPointsLoading) {
                    return Center(
                      child: RefreshProgressIndicator(
                        //color: MyColors.secondaryColor,
                      ),
                    );
                  } else if (state is GetPointsFailed)
                    return Center(
                      child: Text('0'),
                    );
                  else {
                    int points = context.read<PointsBloc>().points;
                    return Text(
                      '$points',
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
