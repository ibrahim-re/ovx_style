import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/profile/widgets/profile_image_section.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/model/user.dart';
import 'package:shimmer_image/shimmer_image.dart';

class OtherUserProfile extends StatefulWidget {
  final navigator;
  final User user;

  const OtherUserProfile({Key? key, this.navigator, required this.user})
      : super(key: key);

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  void initState() {
    context
        .read<OfferBloc>()
        .add(GetUserOffers(widget.user.id!, widget.user.userType!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // BlocProvider<CoverPhotoBloc>(
          //   create: (context) => CoverPhotoBloc(),
          //   child: ProfileImageSection(
          //     uId: user.id,
          //     coverImage: user.coverImage,
          //     profileImage: user.profileImage,
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: double.infinity,
            height: screenHeight * 0.3,
            alignment: Alignment.topCenter,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                CoverImage(
                  coverImage: widget.user.coverImage!,
                ),
                //if user if current logged in, he can change his cover photo
                Positioned(
                  bottom: -70,
                  child: widget.user.profileImage != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: ProgressiveImage(
                            imageError: 'assets/images/no_internet.png',
                            image: widget.user.profileImage!,
                            height: screenHeight * 0.19,
                            width: screenHeight * 0.19,
                          ),
                        )
                      : CircleAvatar(
                          radius: 75,
                          //child: Image.asset('assets/images/add_image.png', fit: BoxFit.fill,),
                          backgroundImage:
                              AssetImage('assets/images/default_profile.jpg'),
                        ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.user.userName ?? '',
                  style: Constants.TEXT_STYLE4,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.userCode ?? '',
                      style: Constants.TEXT_STYLE4
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.user.userCode));
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
                              widget.user.offersAdded!.length.toString(),
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
                              widget.user.offersLiked!.length.toString(),
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
                    widget.user.shortDesc ?? '',
                    textAlign: TextAlign.center,
                    style: Constants.TEXT_STYLE4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<OfferBloc, OfferState>(builder: (ctx, state) {
            if (state is GetUserOffersFailed)
              return Center(
                child: Text(state.message, style: Constants.TEXT_STYLE9),
              );
            else if (state is GetUserOffersDone) {
              if (state.offers.isNotEmpty)
                return OffersListView(
                  fetchedOffers: state.offers,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                );
              else
                return Center(
                  child: Text(
                    'no offers yet'.tr(),
                    style: Constants.TEXT_STYLE8.copyWith(
                      color: MyColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
            } else
              return Center(
                  child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ));
          }),
        ],
      ),
    );
  }
}
