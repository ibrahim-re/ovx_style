import 'dart:io';

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

class SendMessage extends ChatEvents {
  final String roomId;
  final String message;

  SendMessage(this.roomId, this.message);
}

class FetchRoomMessages extends ChatEvents {
  final String roomId;
  FetchRoomMessages(this.roomId);
}

class UploadeImageToRoom extends ChatEvents {
  final String roomId;
  final File Image;

  UploadeImageToRoom(this.roomId, this.Image);
}
