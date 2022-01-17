import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/user.dart';

abstract class DatabaseRepository {
  Future<void> addUserData(String path, Map<String, dynamic> data);
  Future<Map<String, dynamic>> getUserData(String path);
  Future<void> updateOfferAdded(String path, String offerId);
  Future<List<String>> uploadFilesToStorage(List<String> filePaths, String uId, String path);
  Future<User> getUserById(String uId);
  Future<void> updateOfferLiked(String offerId, String userId, bool likeOrDislike);
  Future<void> updateComments(String offerId, String userId);
  Future<String> getUserType(String uId);
}

class DatabaseRepositoryImpl extends DatabaseRepository {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<void> addUserData(String path, Map<String, dynamic> data) {
    return _users.doc(path).set(data);
  }

  @override
  Future<Map<String, dynamic>> getUserData(String path) async {
    final documentSnapshot = await _users.doc(path).get();
    final data = documentSnapshot.data() as Map<String, dynamic>;

    return data;
  }

  @override
  Future<void> updateOfferAdded(String path, String offerId) async {
    try {
      await _users.doc(path).update({'offerAdded': FieldValue.arrayUnion([offerId]),
      }).then((_) {SharedPref.currentUser.offersAdded!.add(offerId);});


      print(SharedPref.currentUser.offersAdded!.length);

    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<List<String>> uploadFilesToStorage(List<String> filePaths, String folderName, String path) async {
    try {
      List<String> urls = [];
      for(String s in filePaths){
        String fileName = Helper().generateRandomName();
        UploadTask uploadTask = _firebaseStorage.ref('$folderName/$path/$fileName}').putFile(File(s));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String url = await taskSnapshot.ref.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw 'error';
    }
  }

  @override
  Future<User> getUserById(String uId) async {
    try {
      final snapshot = await _users.doc(uId).get();
      final userData = snapshot.data() as Map<String, dynamic>;
      final User user;

      if(userData['userType'] == UserType.Person.toString()){
        user = PersonUser.fromMap(userData, uId);
      }
      else{
        user = CompanyUser.fromMap(userData, uId);
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateOfferLiked(String offerId, String userId, bool likeOrDislike) async {
    try {

      if(likeOrDislike)
        await _users.doc(userId).update({'offerLiked': FieldValue.arrayUnion([offerId]),
        }).then((_) {SharedPref.currentUser.offersLiked!.add(offerId);});
      else
        await _users.doc(userId).update({'offerLiked': FieldValue.arrayRemove([offerId]),
        }).then((_) {SharedPref.currentUser.offersLiked!.remove(offerId);});

    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<void> updateComments(String offerId, String userId) async {
    try {
      if(SharedPref.currentUser.comments!.contains(offerId))
        await _users.doc(userId).update({'comments': FieldValue.arrayRemove([offerId]),
      }).then((_) {SharedPref.currentUser.comments!.remove(offerId);});

      else
        await _users.doc(userId).update({'comments': FieldValue.arrayUnion([offerId]),
        }).then((_) {SharedPref.currentUser.comments!.add(offerId);});

    } catch (e) {
    print('error is $e');
    }

  }

  @override
  Future<String> getUserType(String uId) async {
    final snapshot = await _users.doc(uId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    String userType = data['userType'];

    return userType;
  }



}
