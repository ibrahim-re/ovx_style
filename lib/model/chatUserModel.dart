import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUsersModel {
  List<ChatUserModel> allChats = [];

  ChatUsersModel({required this.allChats});

  ChatUsersModel.fromJson(List<QueryDocumentSnapshot<Object?>> data) {
    data.forEach((element) {
      final data = element.data() as Map<String, dynamic>;
      allChats.add(ChatUserModel.fromJson(data));
    });
  }
}

class ChatUserModel {
  String? userId;
  String? userName;
  String? userImage;
  //this id is if the chat already exists
  String? roomId;
  List<String> userOffers = [];

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userImage = json['profileImage'] ?? 'no image';
    userName = json['userName'];
    roomId = json['roomId'] ?? '';
    if (json['offersAdded'] != null) {
      json['offersAdded'].forEach((element) {
        userOffers.add(element);
      });
    }
  }
}
