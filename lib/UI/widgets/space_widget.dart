import 'package:flutter/material.dart';

class VerticalSpaceWidget extends StatelessWidget {
  final heightPercentage;

  VerticalSpaceWidget({@required this.heightPercentage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * heightPercentage,
    );
  }
}


class HorizontalSpaceWidget extends StatelessWidget {
  final widthPercentage;

  HorizontalSpaceWidget({@required this.widthPercentage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * widthPercentage,
    );
  }
}