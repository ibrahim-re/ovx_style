import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class imagePostimageSection extends StatelessWidget {
  const imagePostimageSection({Key? key}) : super(key: key);
  final String userImage =
      "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg";

  final String productImage =
      'https://image.freepik.com/free-vector/white-product-podium-with-green-tropical-palm-leaves-golden-round-arch-green-wall_87521-3023.jpg';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
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
          Positioned(
            bottom: -26,
            right: 0,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: MyColors.secondaryColor,
              ),
              offset: Offset(-10, 40),
              padding: const EdgeInsets.all(0),
              shape: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    height: 4,
                    onTap: () {
                      print('Share');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share),
                        const SizedBox(width: 10),
                        Text('Share'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 4,
                    onTap: () {
                      print('copy link');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotatedBox(
                          quarterTurns: 5,
                          child: Icon(Icons.link_outlined),
                        ),
                        const SizedBox(width: 10),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 4,
                    onTap: () {
                      print('Report');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bug_report_rounded),
                        const SizedBox(width: 10),
                        Text('Report'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          )
        ],
      ),
    );
  }
}
