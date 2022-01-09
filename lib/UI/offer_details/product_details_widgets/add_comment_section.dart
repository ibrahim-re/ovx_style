import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class addcommentSection extends StatelessWidget {
  const addcommentSection({Key? key}) : super(key: key);
  final String userImage =
      "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: Image(image: NetworkImage(userImage)).image,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Comment',
                  ),
                )),
                IconButton(
                    splashRadius: 10,
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: MyColors.secondaryColor,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
