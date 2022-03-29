import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/bill.dart';
import 'package:ovx_style/model/chatUserModel.dart';
import 'package:ovx_style/model/gift.dart';
import 'package:ovx_style/model/group_model.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:ovx_style/model/notification.dart';
import 'package:ovx_style/model/user.dart';

abstract class DatabaseRepository {
  Future<List<User>> searchForUsers(String textToSearch);
  Future<QuerySnapshot<Object?>> GetContacts();
  Future<ChatUsersModel> getChats(String userId);
  Future<void> addUserData(String path, Map<String, dynamic> data);
  Future<void> createRoom(String loggeduserId, String anotherUserId,);
  Future<void> createGroup(GroupModel groupModel);
  Future<List<GroupModel>> getGroups (String userId);
  Future<String> checkIfRoomExists(String firstUserId, String secondUserId);
  Future<void> markMessageAsRead(String msgId, String roomId);
  Future<void> markGroupMessageAsRead(String msgId, String groupId);
  Stream<List<Message>> getChatMessages(String roomId);
  Stream<List<GroupMessage>> getGroupChatMessages(String groupId);
  Stream<Message> getLastMessage(String roomId);
  Future<List<Message>> getMoreMessages(String roomId, String lastFetchedMessageId);
  Future<List<GroupMessage>> getMoreGroupMessages(String roomId, String lastFetchedMessageId);
  Stream<GroupMessage> getGroupLastMessage(String groupId);
  Stream<int> checkForUnreadMessages(String userId);
  Future<void> sendMessage(String roomId, String message);
  Future<void> sendGroupMessage(String groupId, GroupMessage groupMessage);
  Future<void> sendVoice(String roomId, String message, ChatType chatType);
  Future<User> getUserData(String userId);
  Future<void> updateUserData(Map<String, dynamic> userData, String userId);
  Future<void> updateOfferAdded(String userId, String offerId);
  Future<String> uploadImageToRoom(String roomId, File Image, ChatType chatType);
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
}

//https://console.firebase.google.com/u/1/project/ovx-style-de43a/firestore/data/~2F

class DatabaseRepositoryImpl extends DatabaseRepository {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  CollectionReference _billsRequests = FirebaseFirestore.instance.collection('bills requests');
  CollectionReference _chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference _groupChats = FirebaseFirestore.instance.collection('group chats');
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

// fetch all users for chatContacts
  @override
  Future<QuerySnapshot<Object?>> GetContacts() async {
    try {
      List<String> chatCountries = SharedPref.getChatCountries();
      final data = await _users
          .limit(20)
          .where('userId', isNotEqualTo: SharedPref.getUser().id,)
          .where('country', whereIn: chatCountries)
          .get();

      return data;
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  // open chat Room
  @override
  Future<String> createRoom(String firstUserId, String secondUserId) async {
    try {
      final roomId = firstUserId + secondUserId;

      await FirebaseFirestore.instance.collection('chats').doc(roomId).set(
        {
          'roomId': roomId,
          'firstUserId': firstUserId,
          'secondUserId': secondUserId,
        },
      );

      return roomId;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> sendMessage(String roomId, String message) async {
    final String selectedId = _chats
        .doc(roomId)
        .collection('Messages')
        .doc()
        .id;

    await _chats
        .doc(roomId)
        .collection('Messages')
        .doc(selectedId)
        .set({
      'msgType': 0,
      'msgId': selectedId,
      'msgValue': message,
      'isRead': false,
      'sender': SharedPref.getUser().id!,
      'createdAt': DateTime.now(),
    });
  }

  @override
  Future<String> uploadImageToRoom(String roomId, File Image, ChatType chatType) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('chatsImages/$roomId/${Image.path.split('/').last}')
        .putFile(Image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();


    CollectionReference ref = chatType == ChatType.Chat ? _chats : _groupChats;

    final String selectedId = ref
        .doc(roomId)
        .collection('Messages')
        .doc()
        .id;

    if(chatType == ChatType.Chat)
      await ref
        .doc(roomId)
        .collection('Messages')
        .doc(selectedId)
        .set({
      'createdAt': DateTime.now(),
      'sender': SharedPref.getUser().id,
      'msgId': selectedId,
      'msgType': 1,
      'isRead': false,
      'msgValue': url
    });
    else
      await ref
          .doc(roomId)
          .collection('Messages')
          .doc(selectedId)
          .set({
        'createdAt': DateTime.now(),
        'sender': SharedPref.getUser().id,
        'msgId': selectedId,
        'msgType': 1,
        'readBy': [],
        'msgValue': url,
        'senderImage': SharedPref.getUser().profileImage,
        'senderName': SharedPref.getUser().userName,
      });

    return url;
  }

  @override
  Future<void> addUserData(String path, Map<String, dynamic> data) {
    try {
      data['userId'] = path;
      return _users.doc(path).set(data);
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
  Future<List<String>> uploadFilesToStorage(List<String> filePaths, String folderName, String path, {offerId}) async {
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
  Future<void> updateOfferLiked(String offerId, String userId, bool likeOrDislike) async {
    try {
      if (likeOrDislike) {
        await _users.doc(userId).update({
          'offersLiked': FieldValue.arrayUnion([offerId]),
        }).then((_) {
          SharedPref.addOfferLiked(offerId);
        });

        //if not guest add points
        if (SharedPref.getUser().userType != UserType.Guest.toString())
          addPoints(1, userId);
      } else {
        await _users.doc(userId).update({
          'offersLiked': FieldValue.arrayRemove([offerId]),
        }).then((_) {
          SharedPref.deleteOfferLiked(offerId);
        });

        //if not guest remove points
        if (SharedPref.getUser().userType != UserType.Guest.toString())
          removePoints(1, userId);
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
    print('token is $token');
    print('user ifd is $userId');

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
      final querySnapshot =
          await _users.where('userCode', isEqualTo: userCode).get();

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
  Future<void> sendPoints(String senderId, String receiverId, int pointsAmount) async {
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
  Future<ChatUsersModel> getChats(String userId) async {
    ChatUsersModel model = ChatUsersModel(allChats: []);
    //get all chats
    final querySnapshot = await _chats.get();
    //check chats that this user is part of
    for (var doc in querySnapshot.docs) {
      if (doc.id.contains(userId)) {
        //get another user
        final roomId = doc.id;
        final chatData = doc.data() as Map<String, dynamic>;
        String myId = SharedPref.getUser().id!;
        String anotherUserId = chatData['firstUserId'] == myId
            ? chatData['secondUserId']
            : chatData['firstUserId'];
        User anotherUser = await getUserById(anotherUserId);

        model.allChats.add(ChatUserModel.fromJson({
          'userId': anotherUserId,
          'roomId': roomId,
          'userName': anotherUser.userName,
          'profileImage': anotherUser.profileImage,
          'offersAdded': anotherUser.offersAdded,
        }));
      }
    }

    return model;
  }

  @override
  Future<String> checkIfRoomExists(String firstUserId, String secondUserId) async {
    String roomId = '';
    final querySnapshot = await _chats.get();

    for (var doc in querySnapshot.docs) {
      if (doc.id.contains(firstUserId) && doc.id.contains(secondUserId)){
        roomId = doc.id;
        break;
      }
    }

    return roomId;
  }


  //a stream to get messages when updated
  @override
  Stream<List<Message>> getChatMessages(String roomId) async* {
    List<Message> fetchedMessages = [];
    final snapshots = _chats
        .doc(roomId)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots();

    await for (var snapshot in snapshots) {
      //clear list to avoid repeating
      fetchedMessages = [];
      for (var doc in snapshot.docs) {
        Message message = Message.fromJson(doc.data());
        //if sender is not me, mark message as read
        if(message.sender != SharedPref.getUser().id && message.isRead == false)
          await markMessageAsRead(message.msgId!, roomId);
        fetchedMessages.add(message);
      }

      print('getted');


      yield fetchedMessages;
    }
  }

  //stream to get last message when updated
  @override
  Stream<Message> getLastMessage(String roomId) async* {
    late Message lastMessage;
    final snapshots = _chats
        .doc(roomId)
        .collection('Messages')
        .orderBy('createdAt')
        .snapshots();
    await for (var snapshot in snapshots) {
      if(snapshot.docs.isNotEmpty)
        lastMessage = Message.fromJson(snapshot.docs.last.data());

      yield lastMessage;
    }

  }

  @override
  Future<void> markMessageAsRead(String msgId, String roomId) async {
    await _chats.doc(roomId).collection('Messages').doc(msgId).update({
      'isRead': true,
    });

    await _users.doc(SharedPref.getUser().id).collection('unreadMessages').doc(msgId).delete();
    print('$msgId marked as read');
  }

  @override
  Stream<int> checkForUnreadMessages(String userId) async* {
    final snapshots = _users.doc(userId).collection('unreadMessages').snapshots();
    await for (var snapshot in snapshots) {
      yield snapshot.docs.length;
    }
  }

  @override
  Future<void> createGroup(GroupModel groupModel) async {
    try {
      //generate group id and add it to firebase
      String id = await _groupChats.doc().id;
      groupModel.groupId = id;
      await _groupChats.doc(id).set(groupModel.toMap());
    } catch (e) {
      throw e;
    }
  }

  @override
  Stream<List<GroupMessage>> getGroupChatMessages(String groupId) async* {
   List<GroupMessage> fetchedMessages = [];
    final snapshots = _groupChats
        .doc(groupId)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots();
    await for (var snapshot in snapshots) {
      fetchedMessages = [];
      for (var doc in snapshot.docs) {
        GroupMessage groupMessage = GroupMessage.fromJson(doc.data());
        //if sender is not me, mark message as read
        String myId = SharedPref.getUser().id!;
        if(groupMessage.sender != myId && !groupMessage.readBy!.contains(myId))
          await markGroupMessageAsRead(groupMessage.msgId!, groupId);
        fetchedMessages.add(groupMessage);
      }

      print('getted ${fetchedMessages.length}');

      yield fetchedMessages;
    }
  }

  @override
  Future<List<GroupModel>> getGroups(String userId) async {
    try{
      List<GroupModel> fetchedGroups = [];
      final querySnapshot = await _groupChats.where('usersId', arrayContains: userId).get();
      print(querySnapshot.docs.length);
      for(var doc in querySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        fetchedGroups.add(GroupModel.fromJson(data));
      }

      return fetchedGroups;
    }catch (e){
      throw e;
    }
  }

  @override
  Future<void> markGroupMessageAsRead(String msgId, String groupId) async {
    String myId = SharedPref.getUser().id!;
    await _groupChats.doc(groupId).collection('Messages').doc(msgId).update({
      'readBy': FieldValue.arrayUnion([myId]),
    });

    await _users.doc(myId).collection('unreadMessages').doc(msgId).delete();
    print('$msgId marked as read');
  }

  @override
  Future<List<User>> searchForUsers(String textToSearch) async {
    try{
      List<User> users = [];
      final userNameQuerySnapshot = await _users.where('searchStrings', arrayContains: textToSearch.toLowerCase()).get();
      final userCodeQuerySnapshot = await _users.where('userCode', isEqualTo: textToSearch).get();
      for(var doc in userNameQuerySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        User user = User.fromMap(data, doc.id);
        users.add(user);
      }

      for(var doc in userCodeQuerySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        User user = User.fromMap(data, doc.id);
        users.add(user);
      }


      return users;
    }catch (e){
      throw e;
    }
  }

  @override
  Future<void> sendGroupMessage(String groupId, GroupMessage groupMessage) async {
    final String selectedId = _groupChats.doc(groupId).collection('Messages').doc().id;
    groupMessage.msgId = selectedId;

    await _groupChats.doc(groupId).collection('Messages').doc(selectedId).set(groupMessage.toMap());
    print('message sent');
  }

  @override
  Future<void> sendVoice(String roomId, String message, ChatType chatType) async {

    CollectionReference ref = chatType == ChatType.Chat ? _chats : _groupChats;

    //get id
    final String selectedId = ref.doc(roomId).collection('Messages').doc().id;

    File AudioFile = new File(message);
    final String _storedPath = '${DateTime.now().toString()}' + AudioFile.path.split('/').last;

    UploadTask uploadTask = FirebaseStorage.instance
        .ref('chatsVoices/$roomId/${_storedPath}')
        .putFile(AudioFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();

    if(chatType == ChatType.Chat)
      await ref
        .doc(roomId)
        .collection('Messages')
        .doc(selectedId)
        .set({
      'msgType': 2,
      'msgId': selectedId,
      'msgValue': url,
      'isRead': false,
      'sender': SharedPref.getUser().id!,
      'createdAt': DateTime.now(),
    });
    else
      await ref
          .doc(roomId)
          .collection('Messages')
          .doc(selectedId)
          .set({
        'msgType': 2,
        'msgId': selectedId,
        'msgValue': url,
        'readBy': [],
        'sender': SharedPref.getUser().id!,
        'createdAt': DateTime.now(),
        'senderImage': SharedPref.getUser().profileImage,
        'senderName': SharedPref.getUser().userName,
      });
  }

  @override
  Stream<GroupMessage> getGroupLastMessage(String groupId) async* {
    late GroupMessage lastMessage;
    final snapshots = _groupChats
        .doc(groupId)
        .collection('Messages')
        .orderBy('createdAt')
        .snapshots();
    await for (var snapshot in snapshots) {
      if(snapshot.docs.isNotEmpty) {
        lastMessage = GroupMessage.fromJson(snapshot.docs.last.data());
        yield lastMessage;
      }
    }
  }

  @override
  Future<List<Message>> getMoreMessages(String roomId, String lastFetchedMessageId) async {
    try{
      //print('last is ${_lastFetchedMessage!.data()}');
      List<Message> messages = [];
      final documentSnapshot = await _chats.doc(roomId).collection('Messages').doc(lastFetchedMessageId).get();
      final querySnapshot = await _chats.doc(roomId).collection('Messages')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(documentSnapshot)
          .limit(20)
          .get();

      for(var doc in querySnapshot.docs){
        Message message = Message.fromJson(doc.data());
        messages.add(message);
      }

      return messages;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<GroupMessage>> getMoreGroupMessages(String roomId, String lastFetchedMessageId) async {
    try{
      List<GroupMessage> messages = [];
      final documentSnapshot = await _groupChats.doc(roomId).collection('Messages').doc(lastFetchedMessageId).get();
      final querySnapshot = await _groupChats.doc(roomId).collection('Messages')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(documentSnapshot)
          .limit(20)
          .get();

      for(var doc in querySnapshot.docs){
        GroupMessage groupMessage = GroupMessage.fromJson(doc.data());
        messages.add(groupMessage);
      }

      return messages;
    }catch(e){
      throw e;
    }
  }
}
