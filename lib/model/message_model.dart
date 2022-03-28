import 'package:cloud_firestore/cloud_firestore.dart';

// class RoomsModel {
//   List<RoomModel> rooms = [];
//
//   RoomsModel.fromJson(List<dynamic> data) {
//     data.forEach((element) {
//       rooms.add(RoomModel.fromJson(element));
//     });
//   }
// }
//
// class RoomModel {
//   String? RoomId;
//   String? firstUserID;
//   String? secondUserID;
//   List<Message>? messages = [];
//
//   RoomModel.fromJson(Map<String, dynamic> data) {
//     RoomId = data['RoomId'];
//     firstUserID = data['firstUserID'];
//     secondUserID = data['secondUserID'];
//     data['messages'].forEach((element) {
//       messages!.add(Message.fromJson(element));
//     });
//   }
// }

class GroupMessage {
  String? msgId;
  int? msgType;
  String? msgValue;
  String? sender;
  DateTime? createdAt;
  List<String>? readBy;
  String? senderImage;
  String? senderName;

  GroupMessage({
    this.msgId,
    required this.msgValue,
    required this.readBy,
    required this.sender,
    required this.msgType,
    required this.createdAt,
    required this.senderImage,
    required this.senderName,
});

  GroupMessage.fromJson(Map<String, dynamic> data) {
    msgId = data['msgId'];
    msgType = data['msgType'];
    msgValue = data['msgValue'];
    sender = data['sender'];
    readBy = (data['readBy'] as List<dynamic>).map((id) => id.toString()).toList();
    createdAt = (data['createdAt'] as Timestamp).toDate();
    senderImage = data['senderImage'];
    senderName = data['senderName'];
  }

  Map<String, dynamic> toMap() => {
    'msgId': msgId,
    'msgType': msgType,
    'msgValue': msgValue,
    'sender': sender,
    'createdAt': createdAt,
    'readBy': readBy,
    'senderImage': senderImage,
    'senderName': senderName,
  };
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
    msgType = data['msgType'];
    msgValue = data['msgValue'];
    sender = data['sender'];
    isRead = data['isRead'];
    createdAt = (data['createdAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    'msgId': msgId,
    'msgType': msgType,
    'msgValue': msgValue,
    'sender': sender,
    'createdAt': createdAt,
    'isRead': isRead,

  };
}
