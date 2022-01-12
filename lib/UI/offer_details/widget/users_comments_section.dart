import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class UsersComments extends StatelessWidget {
  const UsersComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> usersComment = [
      {
        "userImage":
            "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg",
        "userName": "Ali zamzam",
        "userComment":
            "its wonderful product its wonderful productits wonderful productits wonderful product",
      },
      {
        "userImage":
            "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg",
        "userName": "Ahmad Ali",
        "userComment": "its wonderful product",
      },
      {
        "userImage":
            "https://image.freepik.com/free-photo/joyful-man-with-broad-smile-has-funny-expression-indicates-aside-advertises-something-amazing_273609-17042.jpg",
        "userName": "Samer zz",
        "userComment": "its wonderful product",
      },
    ];
    return Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: usersComment.map((item) {
          return Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      Image(image: NetworkImage(item['userImage'])).image,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['userName']),
                    Text(item['userComment']),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
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
                            print('Delete Your Account');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image(
                                image: AssetImage('assets/images/trash.png'),
                                width: 16,
                                height: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Text('Delete'),
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
        }).toList(),
      ),
    );
  }
}
