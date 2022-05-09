import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';

class ImageScreen extends StatelessWidget {
  final navigator;
  final imageUrl;
  final heroTag;

  ImageScreen({required this.heroTag, required this.imageUrl, this.navigator});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: GestureDetector(
              onTap: (){
                NamedNavigatorImpl().pop();
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Hero(
            tag: heroTag,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
