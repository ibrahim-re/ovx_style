import 'package:cloud_firestore/cloud_firestore.dart';

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
  String? firstUserID;
  String? secondUserID;
  List<Message>? messages = [];

  RoomModel.fromJson(Map<String, dynamic> data) {
    RoomId = data['RoomId'];
    firstUserID = data['firstUserID'];
    secondUserID = data['secondUserID'];
    data['messages'].forEach((element) {
      messages!.add(Message.fromJson(element));
    });
  }
}

class Message {
  String? msgId;
  int? msgType;
  String? msgValue;
  String? sender;
  DateTime? createdAt;
  bool? isRead;

  Message.fromJson(Map<String, dynamic> data) {
    msgId = data['msgId'];
    msgType = data['type'];
    msgValue = data['value'];
    sender = data['sender'];
    isRead = data['isRead'];
    createdAt = (data['createdAt'] as Timestamp).toDate();
  }
}
