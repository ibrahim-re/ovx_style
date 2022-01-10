import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ovx_style/Utiles/colors.dart';

class featuresSection extends StatelessWidget {
  const featuresSection(
      {Key? key, required this.isReturnAvailable, required this.isShippingFree})
      : super(key: key);

  final bool isReturnAvailable;
  final bool isShippingFree;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Featues',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          isReturnAvailable == false && isShippingFree == false
              ? Container(
                  child: Center(
                    child: Text('There Are No Features For this Product'),
                  ),
                )
              : isReturnAvailable == false
                  ? Container()
                  : Row(
                      children: [
                        SvgPicture.asset('assets/images/return.svg'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Return Easily to all Products'),
                        ),
                        Spacer(),
                        Icon(Icons.done, color: MyColors.lightBlue),
                      ],
                    ),
          const SizedBox(height: 16),
          isShippingFree == false
              ? Container()
              : Row(
                  children: [
                    SvgPicture.asset('assets/images/free.svg'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Free Shipping'),
                    ),
                    Spacer(),
                    Icon(Icons.done, color: MyColors.lightBlue),
                  ],
                ),
        ],
      ),
    );
  }
}
