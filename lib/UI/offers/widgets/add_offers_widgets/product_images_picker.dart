import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_multi_image_widget.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductImagesPicker extends StatefulWidget {
  @override
  _ProductImagesPickerState createState() => _ProductImagesPickerState();
}

class _ProductImagesPickerState extends State<ProductImagesPicker> {
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

        context.read<AddOfferBloc>().updateOfferImages(_imagesPath);
      },
      child: CustomMultiImageWidget(
        imagesPath: _imagesPath,
        hint: 'upload offer photo'.tr(),
      ),
    );
  }
}
