import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'discount_switch.dart';
import 'product_images_picker.dart';
import 'product_properties_widget.dart';
import 'shipping_costs_widget.dart';
import 'status_widget.dart';
import 'v_a_t.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/description_text_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'categories_widget.dart';
import 'features_widget.dart';

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddOfferBloc>(context);
    return BlocListener<AddOfferBloc, AddOfferState>(
      listener: (ctx, state) {
        if(state is AddOfferLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if(state is AddOfferSucceed)
          EasyLoading.showSuccess('offer added'.tr());
        else if(state is AddOfferFailed)
          EasyLoading.showError(state.message);

      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyColors.lightBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'company share'.tr(),
                    textAlign: TextAlign.center,
                    style: Constants.TEXT_STYLE6.copyWith(color: MyColors.grey),
                  ),
                ),
              ),
              VerticalSpaceWidget(
                heightPercentage: 0.025,
              ),
              ProductImagesPicker(),
              VerticalSpaceWidget(
                heightPercentage: 0.025,
              ),
              CustomTextFormField(
                hint: "${'offer name'.tr()} *",
                icon: 'offer_name',
                keyboardType: TextInputType.text,
                validateInput: (_) {},
                saveInput: (_) {},
                onChanged: (userInput){
                  context.read<AddOfferBloc>().updateOfferName(userInput);
                },
              ),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              CategoriesWidget(whereToUse: 'Add Offer',),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              StatusWidget(),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              VATSwitch(),
              DiscountSwitch(),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              DescriptionTextField(
                onSaved: (_) {},
                onChanged: (userInput){
                  context.read<AddOfferBloc>().updateShortDesc(userInput);
                },
              ),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              ProductPropertiesWidget(),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              ShippingCostsWidget(),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              FeaturesWidget(),
              VerticalSpaceWidget(
                heightPercentage: 0.015,
              ),
              CustomElevatedButton(
                color: MyColors.secondaryColor,
                text: 'add offer'.tr(),
                function: () {
                  bloc.add(AddProductOfferButtonPressed(OfferType.Product.toString()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
