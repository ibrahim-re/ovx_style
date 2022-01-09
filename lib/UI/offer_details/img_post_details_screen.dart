import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ovx_style/UI/offer_details/img_post_details_widget/image_section.dart';
import 'package:ovx_style/UI/offer_details/img_post_details_widget/top_section.dart';
import 'package:ovx_style/UI/offer_details/img_post_details_widget/user_comments_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/color_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/descreption_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/featues_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/image_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/ship_to_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/size_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/top_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/users_comments_section.dart';

// this screen show the details of the product
class imagePostDetails extends StatelessWidget {
  final navigator;
  const imagePostDetails({this.navigator});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              imagePosttopSection(),
              imagePostimageSection(),
              const SizedBox(height: 10),
              descreptionSection(),
              addcommentSection(),
              imagePostusersComments(),
            ],
          ),
        ),
      ),
    );
  }
}
