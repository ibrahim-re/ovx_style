import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class StroiesRepo {
  // get all stories
  Future<QuerySnapshot<Map<String, dynamic>>> FetchStories() async {
    final stories =
        await FirebaseFirestore.instance.collection('stories').get();
    return stories;
  }

  Future<void> addStory({
    required File pickedFile,
    required String storyOwnerId,
    required String storyOwnerImage,
    required String storyOwnername,
  }) async {
    //1- uploade
    final String storyUrl = await uploadeStory(pickedFile);

    await FirebaseFirestore.instance.collection('stories').doc().set({
      'ownerId': storyOwnerId,
      'ownerImage': storyOwnerImage,
      'ownerName': storyOwnername,
      'storyUrl': storyUrl,
    });
  }

  Future<String> uploadeStory(File pickedFile) async {
    firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instance;

    final String storyPath = pickedFile.path.split('/').last;
    UploadTask uploadTask =
        _storage.ref('Stories/${storyPath}}').putFile(pickedFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
