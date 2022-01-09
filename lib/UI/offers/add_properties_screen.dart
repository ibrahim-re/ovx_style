import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'widgets/add_offers_widgets/add_size_property.dart';
import 'widgets/add_offers_widgets/color_picker_widget.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';

class AddPropertiesScreen extends StatelessWidget {
  final navigator;

  AddPropertiesScreen({this.navigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('add property'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColorPickerWidget(),
            VerticalSpaceWidget(heightPercentage: 0.02),
            Expanded(
              child: AddSizeProperty(),
            ),
          ],
        ),
      ),
    );
  }
}



