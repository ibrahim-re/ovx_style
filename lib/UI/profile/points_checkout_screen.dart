import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/checkout_item.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_bloc.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_states.dart';
import 'package:ovx_style/bloc/points_bloc/points_bloc.dart';
import 'package:ovx_style/bloc/points_bloc/points_events.dart';
import 'package:provider/src/provider.dart';

class PointsCheckoutScreen extends StatefulWidget {
  const PointsCheckoutScreen(
      {Key? key, required this.navigator, required this.pointsAmount})
      : super(key: key);

  final navigator;
  final int pointsAmount;

  @override
  State<PointsCheckoutScreen> createState() => _PointsCheckoutScreenState();
}

class _PointsCheckoutScreenState extends State<PointsCheckoutScreen> {
  late final total;
  @override
  void initState() {
    //calculate total
    final t = widget.pointsAmount / 1000;
    total = double.parse(t.toStringAsFixed(2));

    String userEmail = SharedPref.getUser().email!;
    String userName = SharedPref.getUser().userName!;

    context.read<PaymentBloc>().add(InitializePayment(
        total, userEmail, userName, 'USD'));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('checkout'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckoutItem(
              text: 'points amount'.tr(),
              value: widget.pointsAmount,
              showCurrency: false,
            ),
            const SizedBox(height: 12,),
            Divider(
              thickness: 2,
              color: MyColors.lightGrey,
            ),
            const SizedBox(height: 12,),
            CheckoutItem(
              text: 'total'.tr(),
              value: '$total' + ' \$',
              showCurrency: false,
            ),
            Spacer(),
            BlocConsumer<PaymentBloc, PaymentState>(
              listener: (ctx, state) {
                if(state is PaymentSuccess){
                  EasyLoading.showSuccess('success'.tr());
                  context.read<PointsBloc>().add(AddPoints(widget.pointsAmount));
                  NamedNavigatorImpl().push(NamedRoutes.HOME_SCREEN, clean: true);
                }
                else if(state is PaymentFailed) {
                  EasyLoading.showError(state.message);
                  NamedNavigatorImpl().pop();
                }
              },
              builder: (ctx, state) {
                if(state is PaymentLoading)
                  return Center(child: CircularProgressIndicator(color: MyColors.secondaryColor,),);
                else
                  return CustomElevatedButton(
                    color: MyColors.secondaryColor,
                    text: 'pay'.tr(),
                    function: () {
                      context.read<PaymentBloc>().add(Pay());
                    },
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
