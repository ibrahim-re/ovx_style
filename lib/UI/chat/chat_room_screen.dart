import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/UI/chat/widgets/messages_stream_builder.dart';
import 'package:ovx_style/UI/chat/widgets/sending_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:shimmer_image/shimmer_image.dart';

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen({
    Key? key,
    this.navigator,
    required this.anotherUserName,
    required this.anotherUserImage,
    required this.roomId,
    required this.userId,
  }) : super(key: key);

  final navigator;
  final String anotherUserName;
  final String anotherUserImage;
  final String roomId, userId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  //String uploadedImageUrl = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {

            //check if offer owner is the logged in user
            if(widget.userId == SharedPref.getUser().id)
              return;
            else{
              try {
                User user = await AuthHelper.getUser(widget.userId);
                NamedNavigatorImpl().push(NamedRoutes.OTHER_USER_PROFILE, arguments: {'user': user});
              } catch (e) {
                if(e.toString() == 'no user found'.tr())
                  EasyLoading.showToast('no user found'.tr());

                print(e.toString());
              }
            }

          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                child: widget.anotherUserImage != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ProgressiveImage(
                          imageError: 'assets/images/no_internet.png',
                          image: widget.anotherUserImage,
                          height: 55,
                          fit: BoxFit.cover,
                          width: 55,
                        ),
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/default_profile.jpg'),
                      ),
              ),
              SizedBox(width: 10),
              Text(
                widget.anotherUserName,
                style: Constants.TEXT_STYLE8,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesStreamBuilder(
              roomId: widget.roomId,
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            decoration: BoxDecoration(color: MyColors.primaryColor, boxShadow: [
              BoxShadow(
                color: MyColors.grey,
                offset: Offset(0, 0),
                blurRadius: 6,
              ),
            ]),
            child: SendingWidget(
              chatType: ChatType.Chat,
              roomId: widget.roomId,
            ),
          ),
        ],
      ),
    );
  }
}
