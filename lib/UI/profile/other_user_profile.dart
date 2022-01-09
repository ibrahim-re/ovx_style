import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/UI/profile/widgets/profile_image_section.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/model/user.dart';

class OtherUserProfile extends StatelessWidget {
  final navigator;
  final User user;

  const OtherUserProfile({Key? key, this.navigator, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(user.userName);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ProfileImageSection(
            profileImage: user.profileImage,
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.userName ?? '',
                  style: Constants.TEXT_STYLE4,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.userCode ?? '',
                      style: Constants.TEXT_STYLE4
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: user.userCode));
                        EasyLoading.showToast(
                            'User code is copied to clipboard');
                      },
                      icon: Icon(
                        Icons.copy_outlined,
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'offers'.tr(),
                              style: Constants.TEXT_STYLE4,
                            ),
                            Text(
                              user.offersAdded!.length.toString(),
                              style:
                                  Constants.TEXT_STYLE4.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 50,
                        color: Colors.grey.shade200,
                      ),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'likes'.tr(),
                              style: Constants.TEXT_STYLE4,
                            ),
                            Text(
                              user.offersLiked!.length.toString(),
                              style:
                              Constants.TEXT_STYLE4.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    user.shortDesc ?? '',
                    textAlign: TextAlign.center,
                    style: Constants.TEXT_STYLE4,),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<OfferBloc, OfferState>(
            builder: (ctx, state) {
              if (state is FetchOffersLoading)
                return WaitingOffersListView();
              else if (state is FetchOffersSucceed)
                return OffersListView(
                  fetchedOffers: state.fetchedOffers,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
              else if (state is FetchOffersFailed)
                return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ));
              else
                return Container();
            },
          ),
        ],
      ),
    );
  }
}
