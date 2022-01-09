import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class SizePicker extends StatefulWidget {
  final chosenSize;
  final Function changeSize;

  SizePicker({required this.chosenSize, required this.changeSize});

  @override
  _SizePickerState createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  List<String> _sizeList = ['Small', 'Medium', 'Large', 'XLarge', 'XXLarge', 'XXXLarge', 'XXXXLarge'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      style: Constants.TEXT_STYLE1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        enabledBorder: Constants.outlineBorder,
        focusedBorder: Constants.outlineBorder,
        errorBorder: Constants.outlineBorder,
        focusedErrorBorder: Constants.outlineBorder,
      ),
      icon: Icon(Icons.keyboard_arrow_down, size: 25, color: MyColors.grey,),
      value: widget.chosenSize,
      items: _sizeList
          .map(
            (item) => DropdownMenuItem(
          child: Text('$item'),
          value: item,
        ),
      )
          .toList(),
      onChanged: (val){
        widget.changeSize(val);
      },
      onSaved: (val){
        print(val);
      },
    );
  }
}
