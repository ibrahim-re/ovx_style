import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/checkout/widgets/send_as_gift_container.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_states.dart';
import 'checkout_item.dart';

class CheckOutWidget extends StatefulWidget {
  CheckOutWidget({
    Key? key,
    required this.subtotal,
    required this.vat,
    required this.shippingCost,
  }) : super(key: key);

  final double subtotal, vat, shippingCost;

  @override
  State<CheckOutWidget> createState() => _CheckOutWidgetState();
}

class _CheckOutWidgetState extends State<CheckOutWidget> {
  late double total;

  @override
  void initState() {
    total = widget.subtotal + widget.vat + widget.shippingCost;
    String userEmail = SharedPref.currentUser.email!;
    String userName = SharedPref.currentUser.userName!;

    context
        .read<PaymentBloc>()
        .add(InitializePayment(total, userEmail, userName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          checkoutItem(
            text: 'subtotal'.tr(),
            value: widget.subtotal,
          ),
          VerticalSpaceWidget(heightPercentage: 0.03),
          checkoutItem(
            text: 'vat'.tr(),
            value: widget.vat,
          ),
          VerticalSpaceWidget(heightPercentage: 0.03),
          checkoutItem(
            text: 'shipping costs'.tr(),
            value: widget.shippingCost,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 30),
            child: Divider(
              color: MyColors.grey.withOpacity(0.2),
              thickness: 4,
            ),
          ),
          checkoutItem(
            text: 'total'.tr(),
            value: total,
          ),
          Spacer(),
          BlocConsumer<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if(state is PaymentSuccess)
                EasyLoading.showInfo('Success');
              else if(state is PaymentFailed)
                EasyLoading.showError(state.message);

            },
            builder: (context, state) {
              if (state is PaymentLoading)
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.secondaryColor,
                  ),
                );
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
          VerticalSpaceWidget(heightPercentage: 0.03),
          SendAsGiftContainer(),
        ],
      ),
    );
  }
}
