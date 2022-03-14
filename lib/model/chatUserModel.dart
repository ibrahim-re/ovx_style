import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUsersModel {
  List<ChatUserModel> allChats = [];

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
  String? userLastMessage = 'no message';
  List<String> userOffers = [];

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userImage = json['profileImage'] ?? 'no image';
    userName = json['userName'];
    if (json['offersAdded'] != null) {
      json['offersAdded'].forEach((element) {
        userOffers.add(element);
      });
    }
  }
}
