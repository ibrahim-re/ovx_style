import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  String? storyId;
  String? ownerId;
  String? ownerImage;
  String? ownerName;
  List<String>? storyUrls;
  String? storyDesc;
  String? ownerCountry;
  DateTime? createdAt;
  List<dynamic> likedBy = [];
  //used for filter stories
  int? age;
  String? gender;

  StoryModel({
    required this.storyId,
    required this.ownerId,
    required this.ownerImage,
    required this.ownerName,
    required this.storyUrls,
    required this.storyDesc,
    required this.ownerCountry,
    required this.createdAt,
    required this.likedBy,
    required this.age,
    required this.gender,
});


  Map<String, dynamic> toMap() => {
    'storyId': storyId,
    'ownerId': ownerId,
    'ownerImage': ownerImage,
    'ownerName': ownerName,
    'storyUrls': storyUrls,
    'storyDesc': storyDesc,
    'ownerCountry': ownerCountry,
    'createdAt': createdAt,
    'likedBy': likedBy,
    'age': age,
    'gender': gender,
  };


  StoryModel.fromJson(Map<String, dynamic> json) {
    storyId = json['storyId'];
    ownerId = json['ownerId'];
    createdAt = (json['createdAt'] as Timestamp).toDate();
    ownerImage = json['ownerImage'];
    ownerName = json['ownerName'];
    storyUrls = (json['storyUrls'] as List<dynamic>).map((e) => e.toString()).toList();
    likedBy = json['likedBy'];
    storyDesc = json['storyDesc'] ?? '';
    ownerCountry = json['ownerCountry'] ?? '';
    gender = json['gender'];
    age = json['age'];
  }


}
