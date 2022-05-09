import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/offer_details/widget/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class videoDetails extends StatefulWidget {
  final navigator;
  final VideoOffer video;
  const videoDetails({
    Key? key,
    this.navigator,
    required this.video,
  }) : super(key: key);

  @override
  State<videoDetails> createState() => _videoDetailsState();
}

class _videoDetailsState extends State<videoDetails> {
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
    _controller = VideoPlayerController.network(widget.video.offerMedia!.first);
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
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          OfferOwnerRow(
            offerOwnerId: widget.video.offerOwnerId,
            offerId: widget.video.id,
          ),
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: screenHeight * 0.3,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: 35,
                        color: MyColors.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                    ),
                  ],
                );
              } else {
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
          const SizedBox(height: 6),
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
                ownerId: widget.video.offerOwnerId,
                deleteFunction: () {
                  context.read<AddOfferBloc>().add(
                        DeleteOfferButtonPressed(
                            widget.video.id!, SharedPref.getUser().userType!, SharedPref.getUser().id!),
                      );
                },
                shareFunction: () async {
                  OfferHelper.shareVideo(widget.video.offerMedia!.first);
                },
                reportFunction: (){
                  String body = 'I want to report this video offer because of: \n\n\n\nOffer ID: ${widget.video.id}';
                  Helper().sendEmail('Report Video Offer [OVX Style App]', body, []);
                },
              ),
            ),
          ),
          AddCommentSection(
            offerId: widget.video.id!,
            offerOwnerId: widget.video.offerOwnerId!,
          ),
          UsersComments(
            offerId: widget.video.id!,
            offerOwnerId: widget.video.offerOwnerId!,
          ),
        ],
      ),
    );
  }
}
