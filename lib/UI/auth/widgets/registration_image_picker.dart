import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_multi_image_widget.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';

class RegistrationImagePicker extends StatefulWidget {
  final save;

  RegistrationImagePicker({required this.save});
  @override
  _RegistrationImagePickerState createState() =>
      _RegistrationImagePickerState();
}

class _RegistrationImagePickerState extends State<RegistrationImagePicker> {
  List<String> _imagesPath = [];
  PickImageHelper pickImageHelper = PickImageHelper();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //take the images and add its path to user info
        final temporaryImages = await pickImageHelper.pickMultiImages();

        setState(() {
          _imagesPath.addAll(temporaryImages.map((e) => e.path).toList());
        });

        widget.save(_imagesPath);
      },
      child: CustomMultiImageWidget(imagesPath: _imagesPath, hint: 'upload reg photo'.tr(),),
    );
  }
}