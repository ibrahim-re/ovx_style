import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesModel {
  List<oneStoryModel> allStories = [];
  StoriesModel.fromJson(QuerySnapshot<Map<String, dynamic>> data) {
    data.docs.forEach((element) {
      allStories.add(oneStoryModel.fromJson(element.data()));
    });
  }
}

class oneStoryModel {
  String? ownerId;
  String? ownerImage;
  String? ownerName;
  String? storyUrl;

  oneStoryModel.fromJson(Map<String, dynamic> json) {
    ownerId = json['ownerId'];
    ownerImage = json['ownerImage'];
    ownerName = json['ownerName'];
    storyUrl = json['storyUrl'];
  }
}
