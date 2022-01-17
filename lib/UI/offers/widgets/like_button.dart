import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/like_bloc/like_bloc.dart';
import 'package:ovx_style/bloc/like_bloc/like_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/like_bloc/like_states.dart';

class LikeButton extends StatefulWidget {
  final offerId;
  final offerOwnerId;

  LikeButton({required this.offerId, required this.offerOwnerId});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;

  @override
  void initState() {
    isLiked = SharedPref.currentUser.offersLiked!.contains(widget.offerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isLiked = !isLiked;
        setState(() {});
        context.read<LikeBloc>().add(LikeButtonPressed(widget.offerId, widget.offerOwnerId, SharedPref.currentUser.id!));
      },
      child: isLiked ? SvgPicture.asset('assets/images/like.svg') : SvgPicture.asset('assets/images/unlike.svg'),
    );
  }
}