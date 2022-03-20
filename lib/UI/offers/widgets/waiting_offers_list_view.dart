import 'package:flutter/material.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:shimmer/shimmer.dart';

class WaitingOffersListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaitingOfferOwnerRow(),
              Expanded(
                child: Shimmer.fromColors(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: MyColors.lightGrey,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  baseColor: MyColors.shimmerBaseColor,
                  highlightColor: MyColors.shimmerHighlightedColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaitingOfferOwnerRow(),
              Expanded(
                child: Shimmer.fromColors(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: MyColors.lightGrey,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  baseColor: MyColors.shimmerBaseColor,
                  highlightColor: MyColors.shimmerHighlightedColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
