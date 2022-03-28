import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/checkout/widgets/checkout_widget.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_bloc.dart';

class checkOutScreen extends StatelessWidget {
  final navigator;
  checkOutScreen({
    Key? key,
    required this.navigator,
    required this.subtotal,
    required this.vat,
    required this.shippingCost,
  }) : super(key: key);

  final double subtotal, vat, shippingCost;

  //acquirer_response_message
  //Approved
  //Expired Card
//Response Received Too Late

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('checkout'.tr()),
      ),
      body: CheckOutWidget(
        subtotal: subtotal,
        vat: vat,
        shippingCost: shippingCost,
      ),
    );
  }
}

