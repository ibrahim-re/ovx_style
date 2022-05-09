import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_bloc.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_events.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';
import 'dart:io';

import 'package:provider/src/provider.dart';
import 'package:shimmer_image/shimmer_image.dart';

class ProfileImageSection extends StatelessWidget {
  final profileImage;

  const ProfileImageSection({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: screenHeight * 0.3,
      alignment: Alignment.topCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BlocConsumer<CoverPhotoBloc, CoverPhotoState>(
            listener: (context, state) {
              if (state is ChangeCoverPhotoLoading)
                EasyLoading.show(status: 'please wait'.tr());
              else if (state is ChangeCoverPhotoFailed)
                EasyLoading.showError(state.message);
              else if (state is ChangeCoverPhotoSuccess)
                EasyLoading.showSuccess('cover changed'.tr());
            },
            builder: (context, state) => CoverImage(
              coverImage: SharedPref.getUser().coverImage!,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () async {
                final imageSource = await PickImageHelper().showPicker(context);
                if (imageSource == null) return;

                File temporaryImage =
                    await PickImageHelper().pickImageFromSource(imageSource);

                context
                    .read<CoverPhotoBloc>()
                    .add(ChangeCoverPhotoButtonPressed(temporaryImage.path));
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.edit,
                  color: MyColors.secondaryColor,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            child: profileImage != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: ProgressiveImage(
                      imageError: 'assets/images/no_internet.png',
                      image: profileImage,
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
          Positioned(
            bottom: -85,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: Text(
                SharedPref.getUser().countryFlag!,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
* BlocBuilder<EditUserBloc, EditUserState>(
            builder: (ctx, state) => Positioned(
              bottom: -70,
              child: profileImage != ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: ProgressiveImage(
                        imageError: 'assets/images/no_internet.png',
                        image: profileImage,
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
          )*/

class CoverImage extends StatelessWidget {
  final String coverImage;

  CoverImage({required this.coverImage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return coverImage.isNotEmpty
        ? ProgressiveImage(
            imageError: 'assets/images/no_internet.png',
            image: coverImage,
            width: double.infinity,
            height: screenHeight * 0.22,
            fit: BoxFit.fitWidth,
          )
        : Image.asset(
            'assets/images/cover.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: screenHeight * 0.22,
          );
  }
}
