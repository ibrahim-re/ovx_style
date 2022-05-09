

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? groupId;
  String? groupAdminId;
  List<String>? usersId;
  String? groupName;
  DateTime? lastUpdated;

  GroupModel({
    this.groupId,
    required this.groupAdminId,
    required this.usersId,
    required this.groupName,
    required this.lastUpdated,
});


  GroupModel.fromJson(Map<String, dynamic> json){
    groupAdminId = json['groupAdminId'];
    usersId = (json['usersId'] as List<dynamic>).map((id) => id.toString()).toList();
    groupId = json['groupId'];
    groupName = json['groupName'];
    lastUpdated = (json['lastUpdated'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'groupAdminId': groupAdminId,
    'usersId': usersId,
    'groupName': groupName,
    'lastUpdated': lastUpdated,
  };
}