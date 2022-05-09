import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/img_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/product_property.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

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
        ImageSection(offerImages: productImages),
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
                  shareFunction: () async {
                    OfferHelper.shareProduct(productImages, offerName, description, categories, status);
                  },
                  reportFunction: (){
                    String body = 'I want to report this product offer because of: \n\n\n\nOffer ID: ${offerId}';
                    Helper().sendEmail('Report Product Offer [OVX Style App]', body, []);
                  },
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
          child: Row(
            children: [
              Text(
                offerName,
                style: Constants.TEXT_STYLE9,
              ),
              Spacer(),
              UserPrivacyPolicyWidget(offerOwnerId: offerOwnerId,),
            ],
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


class UserPrivacyPolicyWidget extends StatefulWidget {
  final String offerOwnerId;

  UserPrivacyPolicyWidget({required this.offerOwnerId});

  @override
  _UserPrivacyPolicyWidgetState createState() => _UserPrivacyPolicyWidgetState();
}

class _UserPrivacyPolicyWidgetState extends State<UserPrivacyPolicyWidget> {
  @override
  void initState() {
    context.read<UserBloc>().add(GetUserPrivacyPolicy(widget.offerOwnerId));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        ModalSheets().showUserPolicySheet(context, widget.offerOwnerId);
      },
      icon: SvgPicture.asset('assets/images/info.svg'),
    );
  }
}
