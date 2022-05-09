import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:min_id/min_id.dart';
import 'package:ovx_style/model/story_model.dart';
import '../../Utiles/shared_pref.dart';

class StoriesRepo {
  // get all stories
  Future<List<StoryModel>> FetchStories(
      {String lastFetchedStoryId = ''}) async {
    String storyCountries = SharedPref.getStoryCountries();

    List<StoryModel> stories = [];
    QuerySnapshot querySnapshot;

    if (lastFetchedStoryId.isNotEmpty) {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('stories')
          .doc(lastFetchedStoryId)
          .get();

      querySnapshot = storyCountries == 'All countries'
          ? await FirebaseFirestore.instance
              .collection('stories')
              .orderBy('createdAt', descending: true)
              .startAfterDocument(documentSnapshot)
              .limit(20)
              .get()
          : await FirebaseFirestore.instance
              .collection('stories')
              .orderBy('createdAt', descending: true)
              .startAfterDocument(documentSnapshot)
              .where('ownerCountry', isEqualTo: storyCountries)
              .limit(20)
              .get();
    } else {
      querySnapshot = storyCountries == 'All countries'
          ? await FirebaseFirestore.instance
              .collection('stories')
              .orderBy('createdAt', descending: true)
              .limit(20)
              .get()
          : await FirebaseFirestore.instance
              .collection('stories')
              .orderBy('createdAt', descending: true)
              .where('ownerCountry', isEqualTo: storyCountries)
              .limit(20)
              .get();
      ;
    }

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      StoryModel storyModel = StoryModel.fromJson(data);

      stories.add(storyModel);
    }

    return stories;
  }

  Future<StoryModel> addStory({
    required List<File> pickedFiles,
    required String storyOwnerId,
    required String storyOwnerImage,
    required String storyOwnerName,
    required String storyOwnerCountry,
    required String storyDesc,
    required int age,
    required String gender,
  }) async {
    //1- upload
    try {
      final String _storyId = MinId.getId();
      final List<String> storyUrls = await uploadStory(pickedFiles, _storyId);

      StoryModel story = StoryModel(
        storyId: _storyId,
        ownerId: storyOwnerId,
        ownerImage: storyOwnerImage,
        ownerName: storyOwnerName,
        storyUrls: storyUrls,
        storyDesc: storyDesc,
        ownerCountry: storyOwnerCountry,
        createdAt: DateTime.now(),
        likedBy: [],
        age: age,
        gender: gender,
      );

      await FirebaseFirestore.instance.collection('stories').doc(_storyId).set(story.toMap());

      return story;
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> uploadStory(List<File> pickedFiles, storyId) async {
    List<String> downloadUrls = [];
    firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instance;
    for (var file in pickedFiles) {
      final String storyPath = file.path.split('/').last;
      UploadTask uploadTask =
          _storage.ref('Stories/${storyId}/${storyPath}}').putFile(file);

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
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  Future<List<StoryModel>> getFilteredStories(
      int minAge, int maxAge, String gender, List<String> countries) async {
    try {
      //if no country picked, then get all available countries
      String storyCountries = SharedPref.getStoryCountries();
      List<StoryModel> stories = [];
      QuerySnapshot querySnapshot;

      if (gender.isEmpty || gender.toLowerCase() == 'gender') {
        if (countries.isEmpty)
          querySnapshot = storyCountries == 'All countries'
              ? await FirebaseFirestore.instance
                  .collection('stories')
                  .where('age',
                      isGreaterThanOrEqualTo: minAge,
                      isLessThanOrEqualTo: maxAge)
                  .get()
              : await FirebaseFirestore.instance
                  .collection('stories')
                  .where('age',
                      isGreaterThanOrEqualTo: minAge,
                      isLessThanOrEqualTo: maxAge)
                  .where('ownerCountry', isEqualTo: storyCountries)
                  .get();
        else
          querySnapshot = await FirebaseFirestore.instance
              .collection('stories')
              .where('age',
                  isGreaterThanOrEqualTo: minAge, isLessThanOrEqualTo: maxAge)
              .where('ownerCountry', whereIn: countries)
              .get();
      } else {
        if (countries.isEmpty)
          querySnapshot = storyCountries == 'All countries'
              ? await FirebaseFirestore.instance
                  .collection('stories')
                  .where('age',
                      isGreaterThanOrEqualTo: minAge,
                      isLessThanOrEqualTo: maxAge)
                  .where('gender', isEqualTo: gender)
                  .get()
              : await FirebaseFirestore.instance
                  .collection('stories')
                  .where('age', isGreaterThanOrEqualTo: minAge, isLessThanOrEqualTo: maxAge)
                  .where('gender', isEqualTo: gender)
                  .where('ownerCountry', isEqualTo: storyCountries)
                  .get();
        else
          querySnapshot = await FirebaseFirestore.instance
              .collection('stories')
              .where('age', isGreaterThanOrEqualTo: minAge, isLessThanOrEqualTo: maxAge)
              .where('gender', isEqualTo: gender)
              .where('ownerCountry', whereIn: countries)
              .get();
      }

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        StoryModel storyModel = StoryModel.fromJson(data);

        stories.add(storyModel);
      }

      stories.sort((a, b) {
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return stories;
    } catch (e) {
      throw e;
    }
  }
}
