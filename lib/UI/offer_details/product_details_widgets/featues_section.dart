import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class featuresSection extends StatelessWidget {
  const featuresSection({Key? key}) : super(key: key);

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
          Row(
            children: [
              Image(image: AssetImage('assets/images/return.png')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('Return Easily to all Products'),
              ),
              Spacer(),
              Icon(Icons.done, color: MyColors.lightBlue),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image(image: AssetImage('assets/images/free.png')),
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
