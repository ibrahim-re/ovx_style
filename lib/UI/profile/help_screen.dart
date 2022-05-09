import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_multi_image_widget.dart';
import 'package:ovx_style/UI/widgets/custom_text_form_field.dart';
import 'package:ovx_style/UI/widgets/description_text_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';

class HelpScreen extends StatefulWidget {
  final navigator;

  const HelpScreen({Key? key, this.navigator}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  PickImageHelper pickImageHelper = PickImageHelper();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  List<String> _imagesPath = [];

  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'help'.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/help.svg',
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  'help'.tr(),
                  style: Constants.TEXT_STYLE8.copyWith(
                    color: MyColors.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: _subjectController,
              hint: 'subject'.tr(),
              validateInput: (p) {},
              saveInput: (p) {},
            ),
            const SizedBox(
              height: 20,
            ),
            DescriptionTextField(
              controller: _detailsController,
              hint: 'details'.tr(),
              onSaved: (p) {},
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: CustomMultiImageWidget(
                imagesPath: _imagesPath,
                hint: 'upload photo'.tr(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              color: MyColors.secondaryColor,
              text: 'send'.tr(),
              function: () async {
                if(_subjectController.text.isNotEmpty && _detailsController.text.isNotEmpty){
                 Helper().sendEmail(
                   _subjectController.text,
                   _detailsController.text,
                   _imagesPath,
                 );
                }else{
                  EasyLoading.showToast('fill all info'.tr());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
