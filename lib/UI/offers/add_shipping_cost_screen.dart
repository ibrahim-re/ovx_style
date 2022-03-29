import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/country_picker.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'widgets/add_offers_widgets/circular_add_button.dart';
import 'widgets/add_offers_widgets/countries_shipping_listview.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class AddShippingCostsScreen extends StatefulWidget {
  final navigator;

  AddShippingCostsScreen({this.navigator});

  @override
  State<AddShippingCostsScreen> createState() => _AddShippingCostsScreenState();
}

class _AddShippingCostsScreenState extends State<AddShippingCostsScreen> {
  TextEditingController _priceController = TextEditingController();
  String _selectedCountry = '';
  bool _shippingSimilarToAllCountries = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add shipping cost'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 1,
                    child: Checkbox(
                      activeColor: MyColors.secondaryColor.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: MyColors.lightGrey, width: 1),
                      ),
                      value: _shippingSimilarToAllCountries,
                      onChanged: (newVal) {
                        setState(
                              () {
                            _shippingSimilarToAllCountries = newVal ?? false;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'make all shipping costs similar'.tr(),
                      style: Constants.TEXT_STYLE3,
                    ),
                  ),
                ],
              ),
              VerticalSpaceWidget(heightPercentage: 0.025),
              if (!_shippingSimilarToAllCountries)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: CountryPicker(
                            saveCountry: (val){
                              _selectedCountry = val.toString();
                            },
                            saveCity: (val){print(val.toString());},
                            showCities: false,
                          ),
                        ),
                        HorizontalSpaceWidget(widthPercentage: 0.015),
                        Expanded(
                          flex: 3,
                          child: CustomTextFormField(
                            controller: _priceController,
                            height: 1,
                            hint: 'price'.tr() + ' (${SharedPref.getCurrency()})',
                            keyboardType: TextInputType.number,
                            validateInput: (p) {},
                            saveInput: (p) {},
                          ),
                        ),
                        HorizontalSpaceWidget(widthPercentage: 0.025),
                        Expanded(
                          flex: 1,
                          child: CircularAddButton(
                            onPressed: () {
                              if (_selectedCountry.isNotEmpty &&
                                  _priceController.text.isNotEmpty) {
                                setState(() {
                                  OfferHelper.shippingCosts.addAll({
                                    _selectedCountry: double.tryParse(
                                        _priceController.text) ??
                                        0,
                                  });
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    VerticalSpaceWidget(heightPercentage: 0.025),
                    CountriesShippingListView(),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      hint: 'all countries selected'.tr(),
                      enabled: false,
                      validateInput: (p) {},
                      saveInput: (P) {},
                    ),
                    VerticalSpaceWidget(heightPercentage: 0.02),
                    CustomTextFormField(
                      controller: _priceController,
                      hint: 'price'.tr() + ' (${SharedPref.getCurrency()})',
                      keyboardType: TextInputType.number,
                      validateInput: (p) {},
                      saveInput: (p) {},
                    ),
                  ],
                ),
              VerticalSpaceWidget(heightPercentage: 0.03),
              CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'add'.tr(),
                function: () {
                  if(_shippingSimilarToAllCountries)
                    context.read<AddOfferBloc>().updateShippingCost({'All countries': double.tryParse(_priceController.text)?? 0});
                  else
                    context.read<AddOfferBloc>().updateShippingCost(OfferHelper.shippingCosts);
                  NamedNavigatorImpl().pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
