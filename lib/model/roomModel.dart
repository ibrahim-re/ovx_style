class RoomsModel {
  List<RoomModel> rooms = [];

  RoomsModel.fromJson(List<dynamic> data) {
    data.forEach((element) {
      rooms.add(RoomModel.fromJson(element));
    });
  }
}

class RoomModel {
  String? RoomId;
  String? myId;
  String? anotherUserId;
  List<Messages>? messages = [];

  RoomModel.fromJson(Map<String, dynamic> data) {
    RoomId = data['RoomId'];
    myId = data['myId'];
    RoomId = data['anotherUserId'];
    data['messages'].forEach((element) {
      messages!.add(Messages.fromJson(element));
    });
  }
}

class Messages {
  String? msgId;
  int? msgtype;
  String? msgvalue;
  String? sender;

  Messages.fromJson(Map<String, dynamic> data) {
    msgId = data['msgId'];
    msgtype = data['type'];
    msgvalue = data['value'];
    sender = data['sender'];
  }
}
