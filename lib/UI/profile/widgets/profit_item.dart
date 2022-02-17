import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:provider/src/provider.dart';

class ProfitItem extends StatefulWidget {
  @override
  State<ProfitItem> createState() => _ProfitItemState();
}

class _ProfitItemState extends State<ProfitItem> {
  @override
  void initState() {
    context.read<BillsBloc>().add(FetchBills());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          NamedNavigatorImpl().push(NamedRoutes.MY_BILLS_SCREEN);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                'profit'.tr(),
                style: Constants.TEXT_STYLE6,
              ),
            ),
            Expanded(
              child: BlocBuilder<BillsBloc, BillsState>(
                builder: (context, state) {
                  if (state is FetchBillsLoading) {
                    return Center(
                      child: RefreshProgressIndicator(
                        //color: MyColors.secondaryColor,
                      ),
                    );
                  } else if (state is FetchBillsFailed)
                    return Center(
                      child: Text('0'),
                    );
                  else {
                    double total = context.read<BillsBloc>().calculateTotalBillsAmount();
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