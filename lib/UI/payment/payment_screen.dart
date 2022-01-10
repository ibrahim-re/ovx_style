import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class paymentScreen extends StatelessWidget {
  final navigator;

  const paymentScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'.tr()),
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              NamedNavigatorImpl().push(NamedRoutes.CheckOut, replace: true);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'You Will Have It according to Your Payment Gateway',
          style: TextStyle(
            fontSize: 50,
          ),
        ),
      )),
    );
  }
}
