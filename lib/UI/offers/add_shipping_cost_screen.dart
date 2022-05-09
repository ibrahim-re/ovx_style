import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/country_picker.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/points_bloc/points_bloc.dart';
import 'package:ovx_style/bloc/points_bloc/points_events.dart';
import 'package:ovx_style/bloc/points_bloc/points_states.dart';
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
  bool pointsPaid = false;

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
                            saveCountry: (val) {
                              _selectedCountry = val.toString();
                            },
                            saveCity: (val) {
                              print(val.toString());
                            },
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
                            onPressed: () async {

                              //user can choose 2 shipping countries, plus his country
                              int countriesCount = context.read<AddOfferBloc>().shippingCosts.length;

                              if (_selectedCountry.isNotEmpty && _priceController.text.isNotEmpty) {

                                if (countriesCount >= 2 && !pointsPaid) {
                                  bool b = await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'note'.tr(),
                                        style: Constants.TEXT_STYLE4,
                                      ),
                                      content: Text(
                                        'more than 3 shipping countries'.tr(),
                                        style: Constants.TEXT_STYLE6
                                            .copyWith(color: MyColors.grey),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            NamedNavigatorImpl().pop(result: false);
                                          },
                                          child: Text(
                                            'cancel'.tr(),
                                            style: Constants.TEXT_STYLE4
                                                .copyWith(color: MyColors.red),
                                          ),
                                        ),
                                        BlocListener<PointsBloc, PointsState>(
                                          listener: (ctx, state) {
                                            if (state is RemovePointsLoading)
                                              EasyLoading.show(status: 'please wait'.tr());
                                            else if (state is RemovePointsFailed) {
                                              EasyLoading.dismiss();
                                              EasyLoading.showError(state.message);
                                              NamedNavigatorImpl().pop(result: false);
                                            } else if (state is RemovePointsSucceed) {
                                              EasyLoading.dismiss();
                                              pointsPaid = true;
                                              NamedNavigatorImpl().pop(result: true);
                                            }
                                          },
                                          child: TextButton(
                                            onPressed: () {
                                              ctx.read<PointsBloc>().add(RemovePoints(1000));
                                            },
                                            child: Text(
                                              'ok'.tr(),
                                              style: Constants.TEXT_STYLE4
                                                  .copyWith(color: MyColors.secondaryColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (b)
                                    setState(() {
                                      context.read<AddOfferBloc>().addToShippingCosts(MapEntry(_selectedCountry, double.tryParse(_priceController.text) ?? 0.0,));
                                    });
                                }
                                else{
                                  setState(() {
                                    context.read<AddOfferBloc>().addToShippingCosts(MapEntry(_selectedCountry, double.tryParse(_priceController.text) ?? 0.0,),);
                                  });

                                }
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
                function: () async {
                  if (_shippingSimilarToAllCountries) {

                    //show remove points dialog
                    bool b = await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          'note'.tr(),
                          style: Constants.TEXT_STYLE4,
                        ),
                        content: Text(
                          'product all countries'.tr(),
                          style: Constants.TEXT_STYLE6
                              .copyWith(color: MyColors.grey),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              NamedNavigatorImpl().pop(result: false);
                            },
                            child: Text(
                              'cancel'.tr(),
                              style: Constants.TEXT_STYLE4
                                  .copyWith(color: MyColors.red),
                            ),
                          ),
                          BlocListener<PointsBloc, PointsState>(
                            listener: (ctx, state) {
                              if (state is RemovePointsLoading)
                                EasyLoading.show(status: 'please wait'.tr());
                              else if (state is RemovePointsFailed) {
                                EasyLoading.dismiss();
                                EasyLoading.showError(state.message);
                                NamedNavigatorImpl().pop(result: false);
                              } else if (state is RemovePointsSucceed) {
                                EasyLoading.dismiss();
                                NamedNavigatorImpl().pop(result: true);
                              }
                            },
                            child: TextButton(
                              onPressed: () {
                                ctx.read<PointsBloc>().add(RemovePoints(1000));
                              },
                              child: Text(
                                'ok'.tr(),
                                style: Constants.TEXT_STYLE4
                                    .copyWith(color: MyColors.secondaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    //if user agree go ahead
                    if (b) {
                      context.read<AddOfferBloc>().clearShippingCosts();
                      context.read<AddOfferBloc>().addToShippingCosts(MapEntry('All countries', double.tryParse(_priceController.text) ?? 0));
                      NamedNavigatorImpl().pop();
                    }
                  }
                  else
                    NamedNavigatorImpl().pop();


                  context.read<AddOfferBloc>().shippingCosts.forEach((key, value) {print('$key $value');});

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
