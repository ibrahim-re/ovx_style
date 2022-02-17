import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/auth/widgets/country_picker.dart';
import 'package:ovx_style/UI/auth/widgets/phone_text_field.dart';
import 'package:ovx_style/UI/checkout/widgets/send_as_gift_container.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late double total;
  String name = '';
  String phone = '';
  String country = '';
  String city = '';
  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    total = widget.subtotal + widget.vat + widget.shippingCost;
    total = double.parse(total.toStringAsFixed(2));

    String userEmail = SharedPref.getUser().email!;
    String userName = SharedPref.getUser().userName!;

    context.read<PaymentBloc>().add(InitializePayment(total, userEmail, userName, SharedPref.getCurrency()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //is user guest or signed
    bool isGuest = SharedPref.getUser().userType == UserType.Guest.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(isGuest)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'shipping info'.tr(),
                      style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(
                      icon: 'person',
                      hint: 'full name'.tr(),
                      validateInput: (userInput) {},
                      saveInput: (userInput) {
                        name = userInput;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    PhoneTextField(
                      validate: (userInput){
                        if(userInput!.isEmpty) return 'enter phone'.tr();

                        return null;
                      },
                      save: (phoneNumber){
                        phone = phone;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'address info'.tr(),
                      style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CountryPicker(
                      saveCountry: (val){ country = val; },
                      saveCity: (val){ city = val ?? ''; },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        NamedNavigatorImpl().push(NamedRoutes.GOOGLE_MAPS_SCREEN, arguments: {
                          'onSave': (lat, long){
                            latitude = lat;
                            longitude = long;
                          },
                        });
                      },
                      child: CustomRedirectWidget(
                        title: 'location on map'.tr(),
                        iconName: 'location_on_map',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'bill info'.tr(),
                      style: Constants.TEXT_STYLE4.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
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
            const SizedBox(height: 60,),
            BlocConsumer<PaymentBloc, PaymentState>(
              listener: (context, state) {
                if(state is PaymentSuccess){
                  EasyLoading.showInfo('Success');
                  final basketItems = context.read<BasketBloc>().basketItems;

                  //if user is guest, take info from the form above
                  // if not take info from sharedPref
                  if(isGuest)
                    context.read<BillsBloc>().add(AddBills(
                      basketItems,
                      name,
                      '',
                      phone,
                      country,
                      city,
                      latitude,
                      longitude,
                    ));
                  else
                    context.read<BillsBloc>().add(AddBills(
                      basketItems,
                      SharedPref.getUser().userName!,
                      SharedPref.getUser().email!,
                      SharedPref.getUser().phoneNumber!,
                      SharedPref.getUser().country!,
                      SharedPref.getUser().city!,
                      SharedPref.getUser().latitude!,
                      SharedPref.getUser().longitude!,
                    ));
                }
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

                      if(isGuest){
                        bool valid = _formKey.currentState!.validate() && latitude != 0 && longitude != 0 && city.isNotEmpty && country.isNotEmpty;

                        if(!valid){
                          EasyLoading.showToast('fill all info'.tr());
                          return;
                        }
                      }

                      context.read<PaymentBloc>().add(Pay());

                    },
                  );
              },
            ),
            VerticalSpaceWidget(heightPercentage: 0.03),
            SendAsGiftContainer(),
          ],
        ),
      ),
    );
  }
}