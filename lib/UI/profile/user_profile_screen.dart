import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offers/offers_screen.dart';
import 'package:ovx_style/UI/profile/widgets/personal_info.dart';
import 'package:ovx_style/UI/profile/widgets/profile_image_section.dart';
import 'package:ovx_style/UI/profile/widgets/settings.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  final navigator;

  const UserProfileScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'profile'.tr(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: iconBadge(
              child: SvgPicture.asset('assets/images/notifications.svg'),
              badgeNumber: 1,
            ),
          ),
          IconButton(
            onPressed: () {
              NamedNavigatorImpl().push(NamedRoutes.EDIT_PROFILE_SCREEN);
            },
            icon: SvgPicture.asset('assets/images/edit_profile.svg'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ProfileImageSection(
            profileImage: SharedPref.currentUser.profileImage,
          ),
          PersonalInfo(),
          //SubscriptionSection(),
          BlocProvider<LogoutBloc>(
            create: (ctx) => LogoutBloc(),
            child: Settings(),
          ),
        ],
      ),
    );
  }
}
