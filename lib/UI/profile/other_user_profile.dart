import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/widgets/offers_list_view.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offers_list_view.dart';
import 'package:ovx_style/UI/profile/widgets/profile_image_section.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/model/user.dart';
import 'package:shimmer_image/shimmer_image.dart';

class OtherUserProfile extends StatelessWidget {
  final navigator;
  final User user;

  const OtherUserProfile({Key? key, this.navigator, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final userOffers = context.read<OfferBloc>().getUserOffers(user.id!);
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
                  coverImage: user.coverImage!,
                ),
                //if user if current logged in, he can change his cover photo
                Positioned(
                  bottom: -70,
                  child: user.profileImage != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: ProgressiveImage(
                            imageError: 'assets/images/no_internet.png',
                            image: user.profileImage!,
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
                    style: Constants.TEXT_STYLE4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (userOffers.isNotEmpty)
            OffersListView(
              fetchedOffers: userOffers,
              scrollPhysics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            )
          else
            Center(
              child: Text(
                'no offers yet'.tr(),
                style: Constants.TEXT_STYLE8.copyWith(
                  color: MyColors.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
