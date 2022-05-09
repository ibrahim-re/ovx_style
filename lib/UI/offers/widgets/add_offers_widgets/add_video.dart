import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_elevated_button.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_bloc.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_state.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';

import '../posts_countries_widget.dart';
import 'available_offers_widget.dart';

class AddVideo extends StatefulWidget {
  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  PickImageHelper pickImageHelper = PickImageHelper();
  String _videoPath = '';
  int availableOffers = 0;

  @override
  void initState() {
    context.read<PackagesBloc>().add(GetAvailableOffersCount(OfferType.Video));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddOfferBloc>(context);
    return BlocListener<AddOfferBloc, AddOfferState>(
      listener: (ctx, state) {
        if (state is AddOfferLoading)
          EasyLoading.show(status: 'please wait'.tr());
        else if (state is AddOfferSucceed){
          EasyLoading.showSuccess('offer added'.tr());
          NamedNavigatorImpl().pop();
        }
        else if (state is AddOfferFailed)
          EasyLoading.showError(state.message);

      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<PackagesBloc, PackagesState>(
              builder: (ctx, state) {
                if (state is GetAvailableOffersFailed)
                  return Center(
                    child: Text(
                      state.message,
                      style: Constants.TEXT_STYLE9,
                      textAlign: TextAlign.center,
                    ),
                  );
                else if (state is GetAvailableOffersDone) {
                  availableOffers = state.availableOffers;
                  return AvailableOffersWidget(
                      availableOffers: availableOffers);
                } else
                  return Center(
                    child: RefreshProgressIndicator(
                      color: MyColors.secondaryColor,
                    ),
                  );
              },
            ),
            VerticalSpaceWidget(
              heightPercentage: 0.025,
            ),
            PostsCountriesWidget(),
            const SizedBox(
              height: 16,
            ),
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
                if(availableOffers == 0){
                  ModalSheets().showNoAvailableOffersDialog(context);
                  return;
                }
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
