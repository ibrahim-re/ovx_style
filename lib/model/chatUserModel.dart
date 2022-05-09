
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel {
  String? userId;
  String? userName;
  String? userImage;
  //this id is if the chat already exists
  String? roomId;
  List<String> userOffers = [];
  //to keep track of chat updated
  DateTime? lastUpdated;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userImage = json['profileImage'] ?? '';
    userName = json['userName'];
    roomId = json['roomId'] ?? '';
    if(json['lastUpdated'] != null)
      lastUpdated = (json['lastUpdated'] as Timestamp).toDate();
    if (json['offersAdded'] != null) {
      json['offersAdded'].forEach((element) {
        userOffers.add(element);
      });
    }
  }
}
