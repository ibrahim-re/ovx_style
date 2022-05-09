import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'circular_add_button.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/product_property.dart';

class AddSizeProperty extends StatefulWidget {
  @override
  _AddSizePropertyState createState() => _AddSizePropertyState();
}

class _AddSizePropertyState extends State<AddSizeProperty> {
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  List<ProductSize> _sizes = [];

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                controller: _sizeController,
                hint: 'size'.tr(),
                keyboardType: TextInputType.number,
                validateInput: (p) {},
                saveInput: (p) {},
              ),
            ),
            HorizontalSpaceWidget(widthPercentage: 0.015),
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                controller: _priceController,
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
                  if (_sizeController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      _sizes.add(ProductSize(
                        size: _sizeController.text,
                        price: double.tryParse(_priceController.text) ?? 0,
                      ));
                    });
                  }
                },
              ),
            ),
          ],
        ),
        VerticalSpaceWidget(heightPercentage: 0.025),
        Expanded(
          child: ListView.builder(
            itemCount: _sizes.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MyColors.lightBlue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _sizes[index].size ?? '',
                            style: Constants.TEXT_STYLE1
                                .copyWith(color: MyColors.secondaryColor),
                          ),
                          Text(
                            _sizes[index].price.toString() + ' ${SharedPref.getCurrency()}',
                            style: Constants.TEXT_STYLE1
                                .copyWith(color: MyColors.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  HorizontalSpaceWidget(widthPercentage: 0.02),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _sizes.removeAt(index);
                        });
                      },
                      child: SvgPicture.asset('assets/images/trash.svg', fit: BoxFit.scaleDown,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomElevatedButton(
          color: MyColors.secondaryColor,
          text: 'add'.tr(),
          function: () {
            if(_sizes.isEmpty)
              return;
            context.read<AddOfferBloc>().updateProperties(_sizes, OfferHelper.tempColor);
            NamedNavigatorImpl().pop();
          },
        ),
      ],
    );
  }
}
