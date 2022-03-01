import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  List<oneStoryModel> allStories = [];
  StoriesModel.fromJson(QuerySnapshot<Map<String, dynamic>> data) {
    data.docs.forEach((element) {
      allStories.add(oneStoryModel.fromJson(element.data(), element.id));
    });
  }
}

class oneStoryModel {
  String? storyId;
  String? ownerId;
  String? ownerImage;
  String? ownerName;
  String? storyUrl;
  String? storyDesc;

  List<dynamic> liked = [];

  oneStoryModel.fromJson(Map<String, dynamic> json, id) {
    storyId = json['storyId'];
    ownerId = json['ownerId'];
    ownerImage = json['ownerImage'];
    ownerName = json['ownerName'];
    storyUrl = json['storyUrl'];
    liked = json['likedBy'];
    storyDesc = json['storyDesc'] ?? '';
  }
}
