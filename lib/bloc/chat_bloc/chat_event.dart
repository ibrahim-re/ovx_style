import 'dart:io';

abstract class ChatEvents {}

class FetchAllChats extends ChatEvents {}

class createRoom extends ChatEvents {
  final String anotherUserId;
  final String myId;
  createRoom(
    this.myId,
    this.anotherUserId,
  );
}

class sendMessage extends ChatEvents {
  final String roomId;
  final Map<String, dynamic> data;

  sendMessage(this.roomId, this.data);
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
