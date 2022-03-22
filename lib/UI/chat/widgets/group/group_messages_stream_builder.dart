import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:shimmer_image/shimmer_image.dart';

import '../message_align.dart';

class GroupMessagesStreamBuilder extends StatefulWidget {
  final String groupId;

  GroupMessagesStreamBuilder({required this.groupId});

  @override
  _GroupMessagesStreamBuilderState createState() =>
      _GroupMessagesStreamBuilderState();
}

class _GroupMessagesStreamBuilderState
    extends State<GroupMessagesStreamBuilder> {
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, GroupMessage>>(
      stream: _databaseRepositoryImpl.getGroupChatMessages(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('error occurred'.tr()),
          );
        }
        if (snapshot.hasData) {
          Map<String, GroupMessage> messages = snapshot.data!;
          List<GroupMessage> fetchedMessages =
              messages.values.toList().reversed.toList();

          return ListView.separated(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              separatorBuilder: (ctx, index) => const SizedBox(
                    height: 12,
                  ),
              itemBuilder: (ctx, index) {
                bool isMe =
                    SharedPref.getUser().id == fetchedMessages[index].sender;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          child: fetchedMessages[index].senderImage != ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: ProgressiveImage(
                                    imageError: 'assets/images/no_internet.png',
                                    image: fetchedMessages[index].senderImage!,
                                    height: 20,
                                    width: 20,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundImage: AssetImage(
                                      'assets/images/default_profile.jpg'),
                                ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          fetchedMessages[index].senderName!,
                          style: Constants.TEXT_STYLE6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6,),
                    MessageAlign(
                        msg: fetchedMessages[index].msgValue!,
                        sender: fetchedMessages[index].sender!,
                        type: fetchedMessages[index].msgType!),
                  ],
                );
              });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.secondaryColor,
            ),
          );
        } else
          return Container();
      },
    );
    ;
  }
}
