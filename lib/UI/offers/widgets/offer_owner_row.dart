import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/like_bloc/like_bloc.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'like_button.dart';
import 'package:ovx_style/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_image/shimmer_image.dart';

class OfferOwnerRow extends StatelessWidget {
  final offerOwnerId;
  final offerId;

  OfferOwnerRow({required this.offerOwnerId, required this.offerId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthHelper.getUser(offerOwnerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return WaitingOfferOWnerRow();
        else if (snapshot.hasData) {
          User user = snapshot.data as User;
          return Row(
            children: [
              GestureDetector(
                onTap: (){

                  //check if offer owner is the logged in user
                  if(offerOwnerId == SharedPref.currentUser.id)
                    NamedNavigatorImpl().push(NamedRoutes.USER_PROFILE_SCREEN);
                  else
                    NamedNavigatorImpl().push(NamedRoutes.OTHER_USER_PROFILE, arguments: {'user': user});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: user.profileImage!.isNotEmpty
                      ? ProgressiveImage(
                          image: user.profileImage ?? '',
                          height: 50,
                          width: 50,
                        )
                      : CircleAvatar(
                          backgroundColor: MyColors.lightGrey,
                          child: Image.asset('assets/images/default_profile.jpg'),
                          radius: 25,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                user.userName ?? '',
                style: Constants.TEXT_STYLE4.copyWith(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              BlocProvider(
                create: (context) => LikeBloc(),
                child: LikeButton(
                  offerId: offerId,
                  offerOwnerId: offerOwnerId,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

/* */
