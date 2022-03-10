import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';

class AddVideo extends StatefulWidget {
  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  PickImageHelper pickImageHelper = PickImageHelper();
  String _videoPath = '';

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
                final imageSource = await pickImageHelper.showPicker(context);
                if (imageSource == null) return;

                final temporaryVideo = await pickImageHelper.pickVideoFromSource(imageSource);

                setState(() {
                  _videoPath = temporaryVideo.path;
                });

              },
              child: Container(
                height: 120,
                decoration: DottedDecoration(
                  shape: Shape.box,
                  strokeWidth: 1.5,
                  dash: const [10, 10],
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: _videoPath.isNotEmpty
                    ? Center(
                  child: Text(
                    'one video added'.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: MyColors.lightGrey),
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.video_collection_outlined,
                      color: MyColors.secondaryColor,
                      size: 30,
                    ),
                    Text(
                      'add video'.tr(),
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: MyColors.lightGrey),
                    ),
                  ],
                ),
              ),
            ),
            VerticalSpaceWidget(
              heightPercentage: 0.02,
            ),
            CustomElevatedButton(
              color: MyColors.secondaryColor,
              text: 'add offer'.tr(),
              function: () {
                if (_videoPath.isEmpty) {
                  EasyLoading.showError('please add video'.tr());
                } else
                  bloc.add(AddVideoOfferButtonPressed(
                      [_videoPath], OfferType.Video.toString()));
              },
            ),
          ],
        ),
      ),);
  }
}
