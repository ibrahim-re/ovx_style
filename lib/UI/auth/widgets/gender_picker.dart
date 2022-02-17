import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderPicker extends StatefulWidget {
  final onSaved;

  GenderPicker({required this.onSaved});
  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  List<String> _genderList = ['Male', 'Female'];
  String _chosenGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      style: Constants.TEXT_STYLE1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        prefixIcon: SvgPicture.asset('assets/images/person.svg', fit: BoxFit.scaleDown,),
        enabledBorder: Constants.outlineBorder,
        focusedBorder: Constants.outlineBorder,
        errorBorder: Constants.outlineBorder,
        focusedErrorBorder: Constants.outlineBorder,
      ),
      icon: Icon(Icons.keyboard_arrow_down, size: 25, color: MyColors.grey,),
      value: _chosenGender,
      items: _genderList
          .map(
            (item) => DropdownMenuItem(
          child: Text('$item'),
          value: item,
        ),
      )
          .toList(),
      onChanged: (val) {
        setState(() {
          _chosenGender = val.toString();
        });
      },
      onSaved: widget.onSaved,
    );
  }
}
