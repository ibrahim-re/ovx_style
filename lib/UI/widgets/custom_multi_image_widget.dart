import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'dart:io';

class CustomMultiImageWidget extends StatelessWidget {
  const CustomMultiImageWidget({
    required this.imagesPath,
    required this.hint,
  });

  final hint;
  final List<String> imagesPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: DottedDecoration(
        shape: Shape.box,
        strokeWidth: 1.5,
        dash: const [10, 10],
        color: MyColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: imagesPath.isNotEmpty
          ? Image.file(
              File(imagesPath.first),
              fit: BoxFit.contain,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset('assets/images/add_image.svg'),
                Text(
                  hint,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: MyColors.lightGrey),
                ),
              ],
            ),
    );
  }
}
