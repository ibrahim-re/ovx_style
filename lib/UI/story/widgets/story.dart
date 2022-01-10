import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class story extends StatelessWidget {
  const story({
    Key? key,
    required this.userName,
    required this.userImage,
    required this.storyImage,
  }) : super(key: key);

  final String userName, userImage, storyImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image(
              image: NetworkImage(storyImage),
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Positioned(
              right: 1,
              child: IconButton(
                splashRadius: 5,
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: MyColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 6,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userImage),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      color: MyColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
