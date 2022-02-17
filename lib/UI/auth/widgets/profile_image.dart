import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';
import 'package:shimmer_image/shimmer_image.dart';

class ProfileImage extends StatefulWidget {
  final saveImage;
  final String defaultImage;

  ProfileImage({required this.saveImage, this.defaultImage = ''});
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  String _imagePath = '';
  PickImageHelper pickImageHelper = PickImageHelper();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //take the image and add its path to user info
        final imageSource = await pickImageHelper.showPicker(context);
        if (imageSource == null) return;

        File temporaryImage = await pickImageHelper.pickImageFromSource(imageSource);

        setState(() {
          _imagePath = temporaryImage.path;
        });
        widget.saveImage(_imagePath);
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.transparent,
        child: _imagePath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  File(_imagePath),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              )
            : widget.defaultImage.isNotEmpty
                ? CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: ProgressiveImage(
                        imageError: 'assets/images/no_internet.png',
                        image: widget.defaultImage,
                        height: 90,
                        width: 90,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: MyColors.lightGrey,
                        borderRadius: BorderRadius.circular(50)),
                    width: 90,
                    height: 90,
                    child: Icon(
                      Icons.camera_alt,
                      color: MyColors.grey,
                    ),
                  ),
      ),
    );
  }
}
