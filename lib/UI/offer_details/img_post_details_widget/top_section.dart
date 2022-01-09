import 'package:flutter/material.dart';

class imagePosttopSection extends StatelessWidget {
  const imagePosttopSection({Key? key}) : super(key: key);
  final String userImage =
      "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(userImage),
          ),
          const SizedBox(width: 6),
          Text(
            'Ali Zamzam',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          Spacer(),
          // GestureDetector(
          //   onTap: () {},
          //   child: Image(
          //     image: AssetImage(
          //       'assets/images/like.png',
          //     ),
          //     width: 30,
          //     height: 30,
          //   ),
          // ),
        ],
      ),
    );
  }
}
