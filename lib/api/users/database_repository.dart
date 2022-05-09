import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/packags/packages_repository.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/bill.dart';
import 'package:ovx_style/model/package.dart';
import 'package:ovx_style/model/gift.dart';
import 'package:ovx_style/model/notification.dart';
import 'package:ovx_style/model/user.dart';

abstract class DatabaseRepository {
  Future<List<User>> searchForUsers(String textToSearch);
  Future<void> addUserData(String path, Map<String, dynamic> data);
  Future<User> getUserData(String userId);
  Future<void> updateUserData(Map<String, dynamic> userData, String userId);
  Future<void> updateOfferAdded(String userId, String offerId);
  Future<void> updateCoverImage(String coverImageURL, String userId);
  Future<List<String>> uploadFilesToStorage(List<String> filePaths, String uId, String path);
  Future<void> deleteFilesFromStorage(List<String> urls);
  Future<User> getUserById(String uId);
  Future<User> getUserByUserCode(String userCode);
  Future<void> updateOfferLiked(String offerId, String userId, bool likeOrDislike);
  Future<void> updateComments(String offerId, String userId);
  Future<String> getUserType(String uId);
  Future<List<MyNotification>> fetchNotifications(String userId);
  Future<List<Bill>> fetchBills(String userId);
  Future<List<Gift>> fetchGifts(String userId);
  Future<void> deleteNotification(String id, String userId);
  Future<void> requestBill(String userId, String billId);
  Future<void> saveDeviceToken(String token, String userId);
  Future<void> deleteDeviceToken(String token, String userId);
  Future<void> addPoints(int amount, String userId);
  Future<void> removePoints(int amount, String userId);
  Future<void> sendPoints(String senderId, String receiverId, int pointsAmount);
  Future<int> getPoints(String uId);
  Future<String> getUserPrivacyPolicy(String userId);
  Future<void> updateUserPrivacyPolicy(String userId, String policy);
  Future<void> changeCountries(CountriesFor countriesFor, String changeTo);
  Future<void> changeUserLocation(double latitude, double longitude, String country);
  Future<bool> getReceiveGifts();
  Future<void> changeReceiveGifts(bool receiveGifts);
}

//https://console.firebase.google.com/u/1/project/ovx-style-de43a/firestore/data/~2F

class DatabaseRepositoryImpl extends DatabaseRepository {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  CollectionReference _billsRequests = FirebaseFirestore.instance.collection('bills requests');
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  CollectionReference _subscriptions = FirebaseFirestore.instance.collection('subscriptions');

  @override
  Future<void> addUserData(String path, Map<String, dynamic> data) async {
    try {
      data['userId'] = path;
      await _users.doc(path).set(data);

      //by default add free package to user account
      if (data['userType'] != UserType.Guest.toString()) {
        PackagesRepositoryImpl packagesRepositoryImpl = PackagesRepositoryImpl();
        Package package = await packagesRepositoryImpl.getFreePackage();
        _subscriptions.doc(path).set(package.toMap());
      }
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<User> getUserData(String userId) async {
    try {
      final documentSnapshot = await _users.doc(userId).get();
      final data = documentSnapshot.data() as Map<String, dynamic>;

      //set user id as path to his info
      if (data['userType'] == UserType.Company.toString()) {
        CompanyUser currentUser = CompanyUser.fromMap(data, userId);

        return currentUser;
      } else {
        PersonUser currentUser = PersonUser.fromMap(data, userId);

        return currentUser;
      }
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<void> updateOfferAdded(String userId, String offerId) async {
    print(' user id $userId');
    print('offer id $offerId');
    try {
      if (SharedPref.getUser().offersAdded!.contains(offerId))
        await _users.doc(userId).update({
          'offersAdded': FieldValue.arrayRemove([offerId]),
        }).then((_) {
          SharedPref.deleteOfferAdded(offerId);
        });
      else
        await _users.doc(userId).update({
          'offersAdded': FieldValue.arrayUnion([offerId]),
        }).then((_) {
          SharedPref.addOfferAdded(offerId);
        });
    } catch (e) {
      print('error isss $e');
    }
    // try {
    //   await _users.doc(userId).update({
    //     'offersAdded': FieldValue.arrayUnion([offerId]),
    //   }).then((_) {
    //     SharedPref.addOfferAdded(offerId);
    //   });
    // } catch (e) {
    //   print('error is $e');
    // }
  }

  @override
  Future<List<String>> uploadFilesToStorage(
      List<String> filePaths, String folderName, String path,
      {offerId}) async {
    try {
      List<String> urls = [];
      for (String s in filePaths) {
        String fileName = Helper().generateRandomName();
        UploadTask uploadTask;

        //if it's offer, add an extra folderName (offer id), this step makes deletion easier
        if (offerId == null)
          uploadTask = _firebaseStorage
              .ref('$folderName/$path/$fileName}')
              .putFile(File(s));
        else
          uploadTask = _firebaseStorage
              .ref('$folderName/$path/$offerId/$fileName}')
              .putFile(File(s));

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

      if(!snapshot.exists)
        throw 'no user found'.tr();

      final userData = snapshot.data() as Map<String, dynamic>;
      final User user;

      if (userData['userType'] == UserType.Company.toString()) {
        user = CompanyUser.fromMap(userData, uId);
      } else {
        user = PersonUser.fromMap(userData, uId);
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateOfferLiked(
      String offerId, String userId, bool likeOrDislike) async {
    try {
      if (likeOrDislike) {
        await _users.doc(userId).update({
          'offersLiked': FieldValue.arrayUnion([offerId]),
        }).then((_) {
          SharedPref.addOfferLiked(offerId);
        });
      } else {
        await _users.doc(userId).update({
          'offersLiked': FieldValue.arrayRemove([offerId]),
        }).then((_) {
          SharedPref.deleteOfferLiked(offerId);
        });
      }
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<void> updateComments(String offerId, String userId) async {
    try {
      if (SharedPref.getUser().comments!.contains(offerId))
        await _users.doc(userId).update({
          'comments': FieldValue.arrayRemove([offerId]),
        }).then((_) {
          SharedPref.deleteOfferComment(offerId);
        });
      else
        await _users.doc(userId).update({
          'comments': FieldValue.arrayUnion([offerId]),
        }).then((_) {
          SharedPref.addOfferComment(offerId);
        });
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<String> getUserType(String uId) async {
    try {
      final snapshot = await _users.doc(uId).get();
      final data = snapshot.data() as Map<String, dynamic>;
      String userType = data['userType'];

      return userType;
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<List<MyNotification>> fetchNotifications(String userId) async {
    try {
      List<MyNotification> fetchedNotifications = [];
      final querySnapshot = await _users
          .doc(userId)
          .collection('notifications')
          .orderBy('date', descending: true)
          .get();

      for (var d in querySnapshot.docs) {
        final id = d.id;
        final data = d.data();
        MyNotification newNotification = MyNotification.fromMap(data, id);
        fetchedNotifications.add(newNotification);
      }

      return fetchedNotifications;
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<List<Bill>> fetchBills(String userId) async {
    try {
      List<Bill> fetchedBills = [];
      final querySnapshot = await _users
          .doc(userId)
          .collection('bills')
          .orderBy('date', descending: true)
          .get();

      for (var d in querySnapshot.docs) {
        final id = d.id;
        final data = d.data();
        Bill bill = Bill.fromMap(data, id);
        fetchedBills.add(bill);
      }

      return fetchedBills;
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<void> deleteNotification(String id, String userId) async {
    try {
      await _users.doc(userId).collection('notifications').doc(id).delete();
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<void> requestBill(String userId, String billId) async {
    try {
      await _billsRequests.add({
        'userId': userId,
        'billId': billId,
      });

      await _users.doc(userId).collection('bills').doc(billId).update({
        'isRequested': true,
      });
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<void> saveDeviceToken(String token, String userId) async {
    try {
      await _users.doc(userId).collection('device tokens').doc(token).set({
        'token': token,
      });
    } catch (e) {
      print('error is $e');
      return;
    }
  }

  @override
  Future<void> deleteDeviceToken(String token, String userId) async {
    try {
      await _users.doc(userId).collection('device tokens').doc(token).delete();
    } catch (e) {
      print('error is $e');
      return;
    }
  }

  @override
  Future<void> addPoints(int amount, String userId) async {
    try {
      await _users.doc(userId).update({
        'points': FieldValue.increment(amount),
      });
    } catch (e) {
      print('error is $e');
      return;
    }
  }

  @override
  Future<void> removePoints(int amount, String userId) async {
    try {
      await _users.doc(userId).update({
        'points': FieldValue.increment(-amount),
      });
    } catch (e) {
      print('error is $e');
      return;
    }
  }

  @override
  Future<List<Gift>> fetchGifts(String userId) async {
    try {
      List<Gift> fetchedGifts = [];
      final querySnapshot = await _users
          .doc(userId)
          .collection('gifts')
          .orderBy('date', descending: true)
          .get();

      for (var d in querySnapshot.docs) {
        final id = d.id;
        final data = d.data();
        Gift gift = Gift.fromMap(data, id);
        fetchedGifts.add(gift);
      }

      return fetchedGifts;
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<User> getUserByUserCode(String userCode) async {
    try {
      final querySnapshot = await _users.where('userCode', isEqualTo: userCode).get();

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      final uId = querySnapshot.docs.first.id;
      final User user;

      if (userData['userType'] == UserType.Company.toString()) {
        user = CompanyUser.fromMap(userData, uId);
      } else {
        user = PersonUser.fromMap(userData, uId);
      }

      print('user from here is ${user.toMap()}');

      return user;
    } catch (e) {
      print('error is $e');
      throw e.toString();
    }
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> userData, String userId) async {
    try {
      await _users
          .doc(userId)
          .update(userData)
          .then((_) => SharedPref.setUser(User.fromMap(userData, userId)));
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<void> deleteFilesFromStorage(List<String> urls) async {
    try {
      urls.forEach((url) async {
        await _firebaseStorage.refFromURL(url).delete();
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateCoverImage(String coverImageURL, String userId) async {
    try {
      await _users.doc(userId).update({
        'coverImage': coverImageURL,
      }).then((_) => SharedPref.updateCoverImage(coverImageURL));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> sendPoints(
      String senderId, String receiverId, int pointsAmount) async {
    try {
      //remove points from sender
      await removePoints(pointsAmount, senderId);
      //add points to receiver
      await addPoints(pointsAmount, receiverId);
    } catch (e) {
      print('error is is $e');
      throw e;
    }
  }

  @override
  Future<int> getPoints(String uId) async {
    try {
      final docSnapshot = await _users.doc(uId).get();
      final data = docSnapshot.data() as Map<String, dynamic>;

      return data['points'] ?? 0;
    } catch (e) {
      print('error is is $e');
      throw e;
    }
  }

  @override
  Future<List<User>> searchForUsers(String textToSearch) async {
    try {
      List<User> users = [];
      final userNameQuerySnapshot = await _users
          .where('searchStrings', arrayContains: textToSearch.toLowerCase())
          .get();
      final userCodeQuerySnapshot = await _users.where('userCode', isEqualTo: textToSearch.toLowerCase()).get();
      for (var doc in userNameQuerySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        User user = User.fromMap(data, doc.id);
        users.add(user);
      }

      for (var doc in userCodeQuerySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        User user = User.fromMap(data, doc.id);
        users.add(user);
      }

      return users;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> getUserPrivacyPolicy(String userId) async {
    try {
      final snapshot = await _users.doc(userId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      return data['privacyPolicy'] ?? '';
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateUserPrivacyPolicy(String userId, String policy) async {
    try {
      await _users.doc(userId).update({
        'privacyPolicy': policy,
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> changeCountries(CountriesFor countriesFor, String changeTo) async {
    try {

      String myId = SharedPref.getUser().id!;
      switch (countriesFor) {
        case CountriesFor.Chat:
          await _users.doc(myId).update({
            'chatCountries': changeTo,
          }).then((value) => SharedPref.updateChatCountries(changeTo));
          break;
        case CountriesFor.Story:
          await _users.doc(myId).update({
            'storyCountries': changeTo,
          }).then((value) => SharedPref.updateStoryCountries(changeTo));
          break;
        case CountriesFor.Posts:
          await _users.doc(myId).update({
            'postsCountries': changeTo,
          }).then((value) => SharedPref.updatePostsCountries(changeTo));
          break;
      }
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  @override
  Future<void> changeUserLocation(double latitude, double longitude, String country) async {
    try {
      String userId = SharedPref.getUser().id!;
      await _users.doc(userId).update({
        'latitude': latitude,
        'longitude': longitude,
        'country': country,
      });
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  @override
  Future<bool> getReceiveGifts() async {
    try {
      String userId = SharedPref.getUser().id!;
      final snapshot = await _users.doc(userId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      return data['receiveGifts'] ?? false;
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  @override
  Future<void> changeReceiveGifts(bool receiveGifts) async {
    try {
      String userId = SharedPref.getUser().id!;
      await _users.doc(userId).update({
        'receiveGifts': receiveGifts,
      });
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }
}
