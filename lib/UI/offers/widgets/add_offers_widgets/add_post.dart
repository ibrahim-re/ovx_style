import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/custom_multi_image_widget.dart';
import 'package:ovx_style/UI/widgets/description_text_field.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';

class AddPost extends StatefulWidget {
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  PickImageHelper pickImageHelper = PickImageHelper();
  TextEditingController _descController = TextEditingController();
  List<String> _imagesPath = [];

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddOfferBloc>(context);
    return BlocListener<AddOfferBloc, AddOfferState>(
      listener: (ctx, state) {
        if (state is AddOfferLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if (state is AddOfferSucceed)
          EasyLoading.showSuccess('offer added'.tr());
        else if (state is AddOfferFailed)
          EasyLoading.showError(state.message);

      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                //take the images and add its path to user info
                final temporaryImages = await pickImageHelper.pickMultiImages();

                setState(() {
                  _imagesPath.addAll(temporaryImages.map((e) => e.path).toList());
                });

              },
              child: CustomMultiImageWidget(
                imagesPath: _imagesPath,
                hint: 'upload offer photo'.tr(),
              ),
            ),
            VerticalSpaceWidget(
              heightPercentage: 0.025,
            ),
            DescriptionTextField(
              onSaved: (p) {},
              controller: _descController,
            ),
            VerticalSpaceWidget(
              heightPercentage: 0.02,
            ),
            CustomElevatedButton(
              color: MyColors.secondaryColor,
              text: 'add offer'.tr(),
              function: () {
                if(_descController.text.isEmpty){
                  EasyLoading.showError('please fill desc'.tr());
                } else
                  bloc.add(AddPostOfferButtonPressed(_imagesPath, _descController.text, OfferType.Post.toString()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
