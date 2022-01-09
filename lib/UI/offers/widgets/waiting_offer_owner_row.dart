import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:shimmer/shimmer.dart';

class WaitingOfferOWnerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Shimmer.fromColors(
            child: CircleAvatar(
              radius: 25,
            ),
            baseColor: MyColors.shimmerBaseColor,
            highlightColor: MyColors.shimmerHighlightedColor,
          ),
        ),
        const SizedBox(width: 10),
        Shimmer.fromColors(
          child: Container(
            height: 15,
            width: 70,
            decoration: BoxDecoration(
              color: MyColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          baseColor: MyColors.shimmerBaseColor,
          highlightColor: MyColors.shimmerHighlightedColor,
        ),
        Spacer(),
        Shimmer.fromColors(
          child: CircleAvatar(
            backgroundColor: MyColors.lightGrey,
            radius: 15,
          ),
          baseColor: MyColors.shimmerBaseColor,
          highlightColor: MyColors.shimmerHighlightedColor,
        ),
      ],
    );
  }
}
