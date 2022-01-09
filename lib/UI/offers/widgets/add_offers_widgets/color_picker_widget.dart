import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class ColorPickerWidget extends StatefulWidget {
  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {

  @override
  void dispose() {
    OfferHelper.tempColor = Colors.transparent;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/images/color.svg', fit: BoxFit.scaleDown,),
      title: Text(
        'colors'.tr(),
        style: Constants.TEXT_STYLE4,
      ),
      trailing: InkWell(
        splashColor: MyColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                'pick color'.tr(),
                style: Constants.TEXT_STYLE4,
              ),
              content: SingleChildScrollView(
                child: ColorPicker(
                  onColorChanged: (Color value) {
                    setState(() {
                      OfferHelper.tempColor = value;
                    });
                  },
                  pickerColor: OfferHelper.tempColor == Colors.transparent
                      ? MyColors.secondaryColor
                      : OfferHelper.tempColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    NamedNavigatorImpl().pop();
                  },
                  child: Text(
                    'ok'.tr(),
                    style: Constants.TEXT_STYLE3,
                  ),
                ),
              ],
            ),
          );
        },
        child: OfferHelper.tempColor == Colors.transparent
            ? SvgPicture.asset('assets/images/color_picker.svg', fit: BoxFit.scaleDown,)
            : CircleAvatar(
                backgroundColor: OfferHelper.tempColor,
                radius: 14,
              ),
      ),
    );
  }
}
