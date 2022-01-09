import 'package:flutter/material.dart';

class ProfileImageSection extends StatelessWidget {
  final profileImage;

  const ProfileImageSection({Key? key, @required this.profileImage}) : super(key: key);

  final String coverImage =
      "https://image.freepik.com/free-vector/realistic-black-backgrounds-with-hexagonal-frames_23-2149164531.jpg";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      height: screenHeight * 0.3,
      alignment: Alignment.topCenter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            fit: BoxFit.cover,
            width: double.infinity,
            height: screenHeight * 0.22,
            image: NetworkImage(coverImage),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.edit),
            ),
          ),
          Positioned(
            bottom: -70,
            child: profileImage != '' ? CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(profileImage!),
            ) : CircleAvatar(
              radius: 75,
              //child: Image.asset('assets/images/add_image.png', fit: BoxFit.fill,),
              backgroundImage: AssetImage('assets/images/default_profile.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
