import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class imageSection extends StatelessWidget {
  const imageSection({Key? key}) : super(key: key);
  final String userImage =
      "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg";

  final String productImage =
      'https://image.freepik.com/free-vector/white-product-podium-with-green-tropical-palm-leaves-golden-round-arch-green-wall_87521-3023.jpg';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(userImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(color: MyColors.primaryColor),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: MyColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Wrap(
            spacing: 4,
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: [
              Text(
                'Food',
                style: TextStyle(color: MyColors.lightBlue),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 14,
              ),
              Text(
                'Healthy',
                style: TextStyle(color: MyColors.lightBlue),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              ),
              Text(
                'morning',
                style: TextStyle(color: MyColors.lightBlue),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'To Get The best Hand Drawn images of you',
                style: TextStyle(fontSize: 20),
              )),
              const SizedBox(width: 10),
              Text(
                '124 \$',
                style: TextStyle(
                    fontSize: 16, decoration: TextDecoration.lineThrough),
              ),
              const SizedBox(width: 4),
              Text(
                '90 \$',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
