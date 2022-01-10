import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class storySliderItem extends StatefulWidget {
  const storySliderItem({Key? key}) : super(key: key);

  @override
  storySliderItemState createState() => storySliderItemState();
}

class storySliderItemState extends State<storySliderItem> {
  RangeValues values = RangeValues(16, 35);
  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: values,
      min: 0,
      max: 100,
      divisions: 10,
      labels: RangeLabels(values.start.toString(), values.end.toString()),
      activeColor: MyColors.secondaryColor,
      inactiveColor: MyColors.grey.withOpacity(.3),
      onChanged: (val) {
        setState(() => values = val);
      },
    );
  }
}
