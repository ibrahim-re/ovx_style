import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/package_widget.dart';
import 'package:ovx_style/UI/widgets/checkout_item.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_bloc.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_events.dart';
import 'package:ovx_style/bloc/payment_bloc/payment_states.dart';
import 'package:ovx_style/model/package.dart';
import 'package:provider/src/provider.dart';

class SubscriptionCheckoutScreen extends StatefulWidget {
  final Package package;
  final navigator;

  SubscriptionCheckoutScreen({Key? key, this.navigator, required this.package})
      : super(key: key);

  @override
  State<SubscriptionCheckoutScreen> createState() => _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState extends State<SubscriptionCheckoutScreen> {

  @override
  void initState() {
    String userEmail = SharedPref.getUser().email!;
    String userName = SharedPref.getUser().userName!;
    double price = (widget.package.price! as int).toDouble();
    context.read<PaymentBloc>().add(InitializePayment(
        price, userEmail, userName, 'USD'));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('checkout'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PackageWidget(package: widget.package),
            const SizedBox(
              height: 12,
            ),
            Divider(
              thickness: 3,
              color: MyColors.lightGrey,
            ),
            const SizedBox(
              height: 12,
            ),
            CheckoutItem(
              text: 'total'.tr(),
              value: '${widget.package.price}' + ' \$',
              showCurrency: false,
            ),
            Spacer(),
            BlocConsumer<PaymentBloc, PaymentState>(
              listener: (ctx, state) {
                if(state is PaymentSuccess){
                  EasyLoading.showSuccess('success'.tr());
                  context.read<PackagesBloc>().add(SubscribeToPackage(widget.package));
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
                    function: () async {
                      bool b = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            'subscribe'.tr(),
                            style: Constants.TEXT_STYLE4,
                          ),
                          content: Text(
                            'any active packages'.tr(),
                            style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                NamedNavigatorImpl().pop(result: false);
                              },
                              child: Text(
                                'cancel'.tr(),
                                style: Constants.TEXT_STYLE4.copyWith(color: MyColors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                NamedNavigatorImpl().pop(result: true);
                              },
                              child: Text(
                                'subscribe'.tr(),
                                style: Constants.TEXT_STYLE4.copyWith(color: MyColors.secondaryColor),
                              ),
                            ),
                          ],
                        ),
                      );

                      if(b)
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
