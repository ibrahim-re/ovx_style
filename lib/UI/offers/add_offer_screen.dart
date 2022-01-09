import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'widgets/add_offers_widgets/add_image.dart';
import 'widgets/add_offers_widgets/add_post.dart';
import 'widgets/add_offers_widgets/add_product.dart';
import 'widgets/add_offers_widgets/add_video.dart';

class AddOfferScreen extends StatelessWidget {
  final navigator;
  final offerType;

  AddOfferScreen({this.navigator, @required this.offerType});

  Widget _buildAddOfferBody(){
    if(offerType == OfferType.Product)
      return AddProduct();
    else if(offerType == OfferType.Video)
      return AddVideo();
    else if(offerType == OfferType.Image)
      return AddImage();
    else
      return AddPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add offer'.tr()),
      ),
      body: _buildAddOfferBody(),
    );
  }
}
