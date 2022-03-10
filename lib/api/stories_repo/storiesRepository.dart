import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:min_id/min_id.dart';
import '../../Utiles/shared_pref.dart';

class StroiesRepo {
  // get all stories
  Future<QuerySnapshot<Map<String, dynamic>>> FetchStories() async {
    final stories = await FirebaseFirestore.instance.collection('stories').orderBy('createdAt', descending: true).get();
    return stories;
  }

  Future<void> addStory({
    required List<File> pickedFiles,
    required String storyOwnerId,
    required String storyOwnerImage,
    required String storyOwnername,
    required String storydesc,
  }) async {
    //1- uploade
    final String _storyId = MinId.getId();
    final List<String> storyUrls = await uploadStory(pickedFiles, _storyId);

    await FirebaseFirestore.instance.collection('stories').doc(_storyId).set({
      'storyId': _storyId,
      'ownerId': storyOwnerId,
      'ownerImage': storyOwnerImage,
      'ownerName': storyOwnername,
      'storyUrls': storyUrls,
      'createdAt': DateTime.now(),
      'storyDesc': storydesc,
      'likedBy': [],
    });
  }

  Future<List<String>> uploadStory(List<File> pickedFiles, storyId) async {
    List<String> downloadUrls = [];
    firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;
    for(var file in pickedFiles){
      final String storyPath = file.path.split('/').last;
      UploadTask uploadTask = _storage.ref('Stories/${storyId}/${storyPath}}').putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String url = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(url);
    }
    return downloadUrls;
  }

  Future<void> setStoryFavorite(String storyId, isDelete) async {
    if (isDelete) {
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .update({
        'likedBy': FieldValue.arrayRemove([SharedPref.getUser().id])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .update({
        'likedBy': FieldValue.arrayUnion([SharedPref.getUser().id])
      });
    }
  }


  Future<void> deleteStory(String storyId, List<String> imageUrls) async {
    try {
      await FirebaseFirestore.instance.collection('stories').doc(storyId).delete();
    } catch (e) {
      throw e;
    }
  }
}
