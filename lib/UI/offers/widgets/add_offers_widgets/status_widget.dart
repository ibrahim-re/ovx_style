import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class StatusWidget extends StatelessWidget {
  final String whereToUse;

  StatusWidget({required this.whereToUse});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showStatusPicker(context, whereToUse);
      },
      child: CustomRedirectWidget(
        iconName: 'status',
        title: "${'status'.tr()} *",
      ),
    );
  }

  showStatusPicker(BuildContext context, String whereToUse) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setNewState) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'new'.tr(),
                    style: Constants.TEXT_STYLE3,
                  ),
                  trailing: whereToUse == 'Add Offer'
                      ? context.read<AddOfferBloc>().status ==
                              OfferStatus.New.toString()
                          ? Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.secondaryColor,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                            )
                      : OfferHelper.status == OfferStatus.New.toString()
                          ? Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.secondaryColor,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                            ),
                  onTap: () {
                    setNewState(() {
                      if (whereToUse == 'Add Offer')
                        context
                            .read<AddOfferBloc>()
                            .updateStatus(OfferStatus.New.toString());
                      else
                        OfferHelper.status = OfferStatus.New.toString();
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    'used'.tr(),
                    style: Constants.TEXT_STYLE3,
                  ),
                  trailing: whereToUse == 'Add Offer'
                      ? context.read<AddOfferBloc>().status ==
                      OfferStatus.Used.toString()
                      ? Icon(
                    Icons.done,
                    size: 20,
                    color: MyColors.secondaryColor,
                  )
                      : CircleAvatar(
                    backgroundColor: Colors.transparent,
                  )
                      : OfferHelper.status == OfferStatus.Used.toString()
                      ? Icon(
                    Icons.done,
                    size: 20,
                    color: MyColors.secondaryColor,
                  )
                      : CircleAvatar(
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () {
                    setNewState(() {
                      if (whereToUse == 'Add Offer')
                        context
                            .read<AddOfferBloc>()
                            .updateStatus(OfferStatus.Used.toString());
                      else
                        OfferHelper.status = OfferStatus.Used.toString();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/*Wrap(
                  children: [
                    InkWell(
                      onTap: (){
                        setNewState((){
                          OfferHelper.offerStatus = OfferStatus.New;
                        });
                      },
                      child: ListTile(
                        title: Text(
                          'new'.tr(),
                          style: Constants.TEXT_STYLE3,
                        ),
                        trailing: OfferHelper.offerStatus == OfferStatus.New? Icon(
                          Icons.done,
                          size: 15,
                          color: MyColors.secondaryColor,
                        ) : Container(),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setNewState((){
                          OfferHelper.offerStatus = OfferStatus.Used;
                        });
                      },
                      child: ListTile(
                        title: Text(
                          'used'.tr(),
                          style: Constants.TEXT_STYLE3,
                        ),
                        trailing: OfferHelper.offerStatus == OfferStatus.Used? Icon(
                          Icons.done,
                          size: 15,
                          color: MyColors.secondaryColor,
                        ) : Container(),
                      ),
                    ),
                  ],
                ),*/
