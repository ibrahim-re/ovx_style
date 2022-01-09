import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/color_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/descreption_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/featues_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/image_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/ship_to_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/size_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/top_section.dart';
import 'package:ovx_style/UI/offer_details/product_details_widgets/users_comments_section.dart';
import 'package:ovx_style/Utiles/colors.dart';

// this screen show the details of the product
class ProductDetails extends StatelessWidget {
  final navigator;
  const ProductDetails({this.navigator});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            topSection(),
            imageSection(),
            descreptionSection(),
            colorSection(),
            sizesSection(),
            featuresSection(),
            shipToSection(),
            addcommentSection(),
            usersComments(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: MyColors.secondaryColor,
        //   onPressed: () {},
        //   mini: true,
        //   child: Image(
        //     image: AssetImage('assets/images/cart.png'),
        //     color: Colors.white70,
        //   ),
        // ),
      ),
    );
  }
}
