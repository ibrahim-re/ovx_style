import 'dart:io';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/group_model.dart';

abstract class ChatEvents {}

class GetContacts extends ChatEvents {}

class GetUserChats extends ChatEvents {
  String userId;

  GetUserChats(this.userId);
}

class CreateRoom extends ChatEvents {
  final String secondUserId;
  final String firstUserId;
  CreateRoom(
    this.firstUserId,
    this.secondUserId,
  );
}

class CreateGroup extends ChatEvents {
  GroupModel groupModel;

  CreateGroup(this.groupModel);
}

class GetGroups extends ChatEvents {
  String userId;

  GetGroups(this.userId);
}

class SendMessage extends ChatEvents {
  final String roomId;
  final String message;
  ChatType chatType;

  SendMessage(this.roomId, this.message, this.chatType);
}

class UploadImageToRoom extends ChatEvents {
  final String roomId;
  final File Image;

  UploadImageToRoom(this.roomId, this.Image);
}

class SendVoice extends ChatEvents {
  final String roomId;
  final String message;

  SendVoice(this.roomId, this.message);
}
