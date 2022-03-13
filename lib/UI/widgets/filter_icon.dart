import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FilterIcon extends StatelessWidget {
  const FilterIcon({Key? key, required this.ontap}) : super(key: key);

  final Function ontap;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ontap();
      },
      icon: SvgPicture.asset('assets/images/filter.svg'),
    );
  }
}
