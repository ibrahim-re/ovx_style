import 'package:flutter/material.dart';
import 'package:ovx_style/UI/offer_details/widget/add_comment_section.dart';
import 'package:ovx_style/UI/offer_details/widget/users_comments_section.dart';
import 'package:ovx_style/UI/offers/widgets/offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

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
          const SizedBox(height: 10),
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
