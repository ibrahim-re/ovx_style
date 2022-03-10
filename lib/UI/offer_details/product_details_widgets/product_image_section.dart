import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/model/product_property.dart';
import 'package:provider/src/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({
    Key? key,
    required this.offerId,
    required this.offerOwnerId,
    required this.productImages,
    required this.description,
    required this.categories,
    required this.status,
    required this.offerName,
    required this.properties,
  }) : super(key: key);

  final List<String> productImages, categories;
  final String description, status, offerOwnerId, offerName, offerId;
  final List<ProductProperty> properties;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 3,
          child: ScrollSnapList(
            itemSize: MediaQuery.of(context).size.height / 3,
            dynamicItemSize: true,
            itemBuilder: (ctx, index) => Image.network(productImages[index],
                width: MediaQuery.of(context).size.height / 3),
            onItemFocus: (int) {},
            itemCount: productImages.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  status == OfferStatus.New.toString()
                      ? "new".tr()
                      : "Used".tr(),
                  style: TextStyle(color: MyColors.primaryColor),
                ),
              ),
              Spacer(),
              BlocListener<AddOfferBloc, AddOfferState>(
                listener: (ctx, state){
                  if(state is DeleteOfferLoading)
                    EasyLoading.show(status: 'please wait'.tr());
                  else if(state is DeleteOfferSucceed){
                    EasyLoading.showSuccess('offer deleted'.tr());
                    NamedNavigatorImpl().pop();
                  }
                  else if(state is DeleteOfferFailed)
                    EasyLoading.showError(state.message);
                },
                child: CustomPopUpMenu(
                  ownerId: offerOwnerId,
                  deleteFunction: () {
                    context.read<AddOfferBloc>().add(
                      DeleteOfferButtonPressed(offerId, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Wrap(
            //spacing: 4,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: categories.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item,
                    style: Constants.TEXT_STYLE7,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: MyColors.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            offerName,
            style: Constants.TEXT_STYLE9,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            description,
            style: Constants.TEXT_STYLE4,
          ),
        ),
      ],
    );
  }
}
