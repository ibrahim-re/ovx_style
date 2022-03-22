import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/group_model.dart';
import 'package:ovx_style/model/message_model.dart';

class OneGroupItem extends StatefulWidget {
  final GroupModel groupModel;

  OneGroupItem({required this.groupModel});

  @override
  State<OneGroupItem> createState() => _OneGroupItemState();
}

class _OneGroupItemState extends State<OneGroupItem> {
  DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NamedNavigatorImpl().push(NamedRoutes.GROUP_CHAT_SCREEN, arguments: {
          'groupModel': widget.groupModel,
        });
      },
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: MyColors.lightGrey,
              child: Center(child: Text('G', style: Constants.TEXT_STYLE8,)),
            ),
            SizedBox(width: 20),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.groupModel.groupName!,
                    style: Constants.TEXT_STYLE4,
                  ),
                StreamBuilder<GroupMessage>(
                      stream: databaseRepositoryImpl.getGroupLastMessage(widget.groupModel.groupId!),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          GroupMessage message = snapshot.data!;
                          bool isRead = true;
                          //if not me who send the message, see if it's read or unread
                          String myId = SharedPref.getUser().id!;
                          if (message.sender != myId)
                            isRead = message.readBy!.contains(myId);

                          return Row(
                            children: [
                              Text(
                                message.msgValue!,
                                style: isRead
                                    ? Constants.TEXT_STYLE6
                                    : Constants.TEXT_STYLE6.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isRead) Spacer(),
                              if (!isRead)
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: MyColors.red,
                                ),
                            ],
                          );
                        } else
                          return Container();
                      },
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
