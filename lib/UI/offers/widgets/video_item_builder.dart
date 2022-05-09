// offer type= video
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:http/http.dart' as http;

class VideoItemBuilder extends StatefulWidget {
  final videoOffer;

  const VideoItemBuilder({Key? key, required this.videoOffer})
      : super(key: key);

  @override
  State<VideoItemBuilder> createState() => _VideoItemBuilderState();
}

class _VideoItemBuilderState extends State<VideoItemBuilder> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');
      setState(() {});
    }
  }

  void playVideo() {
    _controller =
        VideoPlayerController.network(widget.videoOffer.offerMedia.first);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(checkVideo);
  }

  @override
  void initState() {
    playVideo();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final s = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        NamedNavigatorImpl().push(NamedRoutes.Video_Details, arguments: {'video': widget.videoOffer});
      },
      child: Container(
        alignment: Alignment.topCenter,
        height: screenHeight * 0.5,
        //color: MyColors.secondaryColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              height: 70,
              child: OfferOwnerRow(
                offerOwnerId: widget.videoOffer.offerOwnerId,
                offerId: widget.videoOffer.id,
              ),
            ),
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: VideoPlayer(_controller),
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 40,
                            color: MyColors.primaryColor,
                          ),
                          onPressed: () {
                            // Wrap the play or pause in a call to `setState`. This ensures the
                            // correct icon is shown.
                            setState(() {
                              // If the video is playing, pause it.
                              if (_controller.value.isPlaying) {
                                //print(_controller.value.isBuffering);
                                _controller.pause();
                              } else {
                                // If the video is paused, play it.
                                _controller.play();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Shimmer.fromColors(
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: double.infinity,
                      height: 250,
                      color: MyColors.lightGrey,
                    ),
                    baseColor: MyColors.shimmerBaseColor,
                    highlightColor: MyColors.shimmerHighlightedColor,
                  );
                }
              },
            ),
            BlocListener<AddOfferBloc, AddOfferState>(
              listener: (ctx, state) {
                if (state is DeleteOfferLoading)
                  EasyLoading.show(status: 'please wait'.tr());
                else if(state is DeleteOfferSucceed){
                  NamedNavigatorImpl().pop();
                  EasyLoading.showSuccess('offer deleted'.tr());
                }
                else if (state is DeleteOfferFailed)
                  EasyLoading.showError(state.message);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomPopUpMenu(
                  ownerId: widget.videoOffer.offerOwnerId,
                  shareFunction: ()async{
                    OfferHelper.shareVideo(widget.videoOffer.offerMedia.first);
                  },
                  reportFunction: (){
                    String body = 'I want to report this video offer because of: \n\n\n\nOffer ID: ${widget.videoOffer.id}';
                    Helper().sendEmail('Report Video Offer [OVX Style App]', body, []);
                  },
                  deleteFunction: () {
                    context.read<AddOfferBloc>().add(
                      DeleteOfferButtonPressed(
                          widget.videoOffer.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}