import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/checkout/widgets/checkout_button.dart';
import 'package:ovx_style/UI/checkout/widgets/checkout_items.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';

class checkOutScreen extends StatelessWidget {
  final navigator;
  checkOutScreen({Key? key, required this.navigator}) : super(key: key);

  final List<Map<String, dynamic>> tempData = [
    {
      "text": "Sub Total",
      "value": 320.5,
    },
    {
      "text": "V.A.T(10%)",
      "value": 37.5,
    },
    {
      "text": "Shipping Cost",
      "value": 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'.tr()),
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              NamedNavigatorImpl().push(NamedRoutes.Basket, replace: true);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: MyColors.secondaryColor,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemBuilder: (_, index) => checkoutItem(
                    text: tempData[index]['text'],
                    value: tempData[index]['value'].toString(),
                  ),
                  separatorBuilder: (_, index) => const SizedBox(height: 16),
                  itemCount: tempData.length,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Divider(
                color: MyColors.grey.withOpacity(0.2),
                thickness: 4,
                endIndent: 10,
                indent: 10,
              ),
            ),
            checkoutItem(
              text: 'total'.toUpperCase(),
              value: '300',
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    checkoutButton(
                      text: 'Pay'.tr(),
                      ontap: () {
                        NamedNavigatorImpl().push(
                          NamedRoutes.Payment,
                          replace: true,
                          clean: true,
                        );
                      },
                    ),
                    checkoutButton(
                      text: 'Send as A Gift'.tr(),
                      ontap: () {
                        ModalSheets().showSendGift(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
