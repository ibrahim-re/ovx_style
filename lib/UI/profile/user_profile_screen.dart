import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/profile/widgets/personal_info.dart';
import 'package:ovx_style/UI/profile/widgets/profile_image_section.dart';
import 'package:ovx_style/UI/profile/widgets/settings.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/logout_bloc/logout_bloc.dart';

class UserProfileScreen extends StatelessWidget {
  final navigator;

  const UserProfileScreen({Key? key, this.navigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr(),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.category)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
        ],
      ),
      body: ListView(
        children: [
          ProfileImageSection(profileImage: SharedPref.currentUser.profileImage,),
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
