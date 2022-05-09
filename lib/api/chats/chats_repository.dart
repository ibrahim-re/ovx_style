import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/chatUserModel.dart';
import 'package:ovx_style/model/group_model.dart';
import 'package:ovx_style/model/message_model.dart';
import 'package:ovx_style/model/user.dart';

abstract class ChatsRepository {
  Future<List<ChatUserModel>> getContacts();
  Future<List<ChatUserModel>> getFilteredContacts(int minAge, int maxAge, String gender, List<String> countries);
  Future<List<ChatUserModel>> getChats(String userId);
  Future<void> createRoom(String firstUserId, String secondUserId);
  Future<void> createGroup(GroupModel groupModel);
  Future<List<GroupModel>> getGroups(String userId);
  Future<String> checkIfRoomExists(String firstUserId, String secondUserId);
  Future<void> markMessageAsRead(String msgId, String roomId);
  Future<void> markGroupMessageAsRead(String msgId, String groupId);
  Stream<List<Message>> getChatMessages(String roomId);
  Stream<List<GroupMessage>> getGroupChatMessages(String groupId);
  Stream<Message> getLastMessage(String roomId);
  Future<List<Message>> getMoreMessages(String roomId, String lastFetchedMessageId);
  Future<List<GroupMessage>> getMoreGroupMessages(String roomId, String lastFetchedMessageId);
  Stream<GroupMessage> getGroupLastMessage(String groupId);
  Stream<List<UnreadMessage>> checkForUnreadMessages(String userId);
  Future<void> sendMessage(String roomId, String message);
  Future<void> sendGroupMessage(String groupId, GroupMessage groupMessage);
  Future<void> sendVoice(String roomId, String message, ChatType chatType);
  Future<String> uploadImageToRoom(String roomId, File Image, ChatType chatType);
}


class ChatsRepositoryImpl extends ChatsRepository {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  CollectionReference _chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference _groupChats = FirebaseFirestore.instance.collection('group chats');

// fetch all users for chatContacts
  @override
  Future<List<ChatUserModel>> getContacts() async {
    try {
      List<ChatUserModel> contacts = [];
      String chatCountries = SharedPref.getChatCountries();
      final querySnapshot = chatCountries == 'All countries'
          ? await _users
          .where('userType', isNotEqualTo: UserType.Guest.toString())
          .get()
          : await _users
          .where('userType', isNotEqualTo: UserType.Guest.toString())
          .where('country', isEqualTo: chatCountries)
          .get();

      for(var doc in querySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        if(data['userId'] == SharedPref.getUser().id)
          continue;
        ChatUserModel chatUserModel = ChatUserModel.fromJson(data);
        contacts.add(chatUserModel);
      }

      return contacts;
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

      await _chats.doc(roomId).set(
        {
          'roomId': roomId,
          'firstUserId': firstUserId,
          'secondUserId': secondUserId,
          'lastUpdated': DateTime.now(),
        },
      );

      return roomId;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> sendMessage(String roomId, String message) async {
    final String selectedId = _chats.doc(roomId).collection('Messages').doc().id;

    await _chats.doc(roomId).collection('Messages').doc(selectedId).set({
      'msgType': 0,
      'msgId': selectedId,
      'msgValue': message,
      'isRead': false,
      'sender': SharedPref.getUser().id!,
      'createdAt': DateTime.now(),
    });

    _chats.doc(roomId).update({
      'lastUpdated': DateTime.now(),
    });
  }

  @override
  Future<String> uploadImageToRoom(
      String roomId, File Image, ChatType chatType) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('chatsImages/$roomId/${Image.path.split('/').last}')
        .putFile(Image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();

    CollectionReference ref = chatType == ChatType.Chat ? _chats : _groupChats;

    final String selectedId = ref.doc(roomId).collection('Messages').doc().id;

    if (chatType == ChatType.Chat)
      await ref.doc(roomId).collection('Messages').doc(selectedId).set({
        'createdAt': DateTime.now(),
        'sender': SharedPref
            .getUser()
            .id,
        'msgId': selectedId,
        'msgType': 1,
        'isRead': false,
        'msgValue': url
      });
    else
      await ref.doc(roomId).collection('Messages').doc(selectedId).set({
        'createdAt': DateTime.now(),
        'sender': SharedPref.getUser().id,
        'msgId': selectedId,
        'msgType': 1,
        'readBy': [],
        'msgValue': url,
        'senderImage': SharedPref.getUser().profileImage,
        'senderName': SharedPref.getUser().userName,
      });

    ref.doc(roomId).update({
      'lastUpdated': DateTime.now(),
    });
    return url;
  }

  @override
  Future<List<ChatUserModel>> getChats(String userId) async {
    DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
    List<ChatUserModel> chats = [];
    //get all user chats id
    final querySnapshot = await _users.doc(userId).collection('user chats').get();

    for(var doc in querySnapshot.docs){
      String roomId = doc.id;

      //check if there is no messages don't add the chat
      final snapshot = await _chats.doc(roomId).collection('Messages').limit(1).get();
      if(snapshot.docs.isEmpty)
        continue;

      final chatSnapshot = await _chats.doc(roomId).get();
      final chatData = chatSnapshot.data() as Map<String, dynamic>;
      String myId = SharedPref.getUser().id!;
      String anotherUserId = chatData['firstUserId'] == myId
          ? chatData['secondUserId']
          : chatData['firstUserId'];
      try {
        User anotherUser = await databaseRepositoryImpl.getUserById(anotherUserId);
        chats.add(ChatUserModel.fromJson({
          'userId': anotherUserId,
          'roomId': roomId,
          'lastUpdated': chatData['lastUpdated'],
          'userName': anotherUser.userName,
          'profileImage': anotherUser.profileImage,
          'offersAdded': anotherUser.offersAdded,
        }));
      } catch (e) {
        if(e.toString() == 'no user found'.tr()) {
          chats.add(ChatUserModel.fromJson({
            'userId': anotherUserId,
            'roomId': roomId,
            'lastUpdated': chatData['lastUpdated'],
            'userName': 'user'.tr(),
            'profileImage': '',
            'offersAdded': [],
          }));
        }
      }
    }

    chats.sort((a, b) {
      return b.lastUpdated!.compareTo(a.lastUpdated!);
    });
    return chats;
  }

  @override
  Future<String> checkIfRoomExists(String firstUserId, String secondUserId) async {
    String roomId = '';
    String myId = SharedPref.getUser().id!;
    final querySnapshot = await _users.doc(myId).collection('user chats').get();

    for (var doc in querySnapshot.docs) {
      if (doc.id.contains(firstUserId) && doc.id.contains(secondUserId)) {
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
        .limit(30)
        .snapshots();

    await for (var snapshot in snapshots) {
      //clear list to avoid repeating
      fetchedMessages = [];
      for (var doc in snapshot.docs) {
        Message message = Message.fromJson(doc.data());
        //if sender is not me, mark message as read
        if (message.sender != SharedPref.getUser().id &&
            message.isRead == false)
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
      if (snapshot.docs.isNotEmpty)
        lastMessage = Message.fromJson(snapshot.docs.last.data());

      yield lastMessage;
    }
  }

  @override
  Future<void> markMessageAsRead(String msgId, String roomId) async {
    await _chats.doc(roomId).collection('Messages').doc(msgId).update({
      'isRead': true,
    });

    await _users
        .doc(SharedPref.getUser().id)
        .collection('unreadMessages')
        .doc(msgId)
        .delete();
    print('$msgId marked as read');
  }

  @override
  Stream<List<UnreadMessage>> checkForUnreadMessages(String userId) async* {
    List<UnreadMessage> unreadMessages = [];
    final snapshots = _users.doc(userId).collection('unreadMessages').snapshots();
    await for (var snapshot in snapshots) {
      unreadMessages = [];
      for (var doc in snapshot.docs) {
        UnreadMessage unreadMessage = UnreadMessage.fromMap(doc.data());
        unreadMessages.add(unreadMessage);
      }
      yield unreadMessages;
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
        .limit(30)
        .snapshots();
    await for (var snapshot in snapshots) {
      fetchedMessages = [];
      for (var doc in snapshot.docs) {
        GroupMessage groupMessage = GroupMessage.fromJson(doc.data());
        //if sender is not me, mark message as read
        String myId = SharedPref.getUser().id!;
        if (groupMessage.sender != myId && !groupMessage.readBy!.contains(myId))
          await markGroupMessageAsRead(groupMessage.msgId!, groupId);
        fetchedMessages.add(groupMessage);
      }

      print('getted ${fetchedMessages.length}');

      yield fetchedMessages;
    }
  }

  @override
  Future<List<GroupModel>> getGroups(String userId) async {
    try {
      List<GroupModel> fetchedGroups = [];
      final querySnapshot = await _users.doc(userId).collection('user group chats').get();

      for (var doc in querySnapshot.docs) {
        final groupId = doc.id;

        final groupSnapshot = await _groupChats.doc(groupId).get();
        final groupData = groupSnapshot.data() as Map<String ,dynamic>;
        fetchedGroups.add(GroupModel.fromJson(groupData));
      }


      fetchedGroups.sort((a, b) {
        return b.lastUpdated!.compareTo(a.lastUpdated!);
      });
      return fetchedGroups;
    } catch (e) {
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
  Future<void> sendGroupMessage(String groupId, GroupMessage groupMessage) async {
    final String selectedId = _groupChats.doc(groupId).collection('Messages').doc().id;
    groupMessage.msgId = selectedId;

    await _groupChats
        .doc(groupId)
        .collection('Messages')
        .doc(selectedId)
        .set(groupMessage.toMap());

    _groupChats.doc(groupId).update({
      'lastUpdated': DateTime.now(),
    });
  }

  @override
  Future<void> sendVoice(
      String roomId, String message, ChatType chatType) async {
    CollectionReference ref = chatType == ChatType.Chat ? _chats : _groupChats;

    //get id
    final String selectedId = ref.doc(roomId).collection('Messages').doc().id;

    File AudioFile = new File(message);
    final String _storedPath =
        '${DateTime.now().toString()}' + AudioFile.path.split('/').last;

    UploadTask uploadTask = FirebaseStorage.instance
        .ref('chatsVoices/$roomId/${_storedPath}')
        .putFile(AudioFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String url = await taskSnapshot.ref.getDownloadURL();

    if (chatType == ChatType.Chat)
      await ref.doc(roomId).collection('Messages').doc(selectedId).set({
        'msgType': 2,
        'msgId': selectedId,
        'msgValue': url,
        'isRead': false,
        'sender': SharedPref.getUser().id!,
        'createdAt': DateTime.now(),
      });
    else
      await ref.doc(roomId).collection('Messages').doc(selectedId).set({
        'msgType': 2,
        'msgId': selectedId,
        'msgValue': url,
        'readBy': [],
        'sender': SharedPref.getUser().id!,
        'createdAt': DateTime.now(),
        'senderImage': SharedPref.getUser().profileImage,
        'senderName': SharedPref.getUser().userName,
      });

    ref.doc(roomId).update({
      'lastUpdated': DateTime.now(),
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
      if (snapshot.docs.isNotEmpty) {
        lastMessage = GroupMessage.fromJson(snapshot.docs.last.data());
        yield lastMessage;
      }
    }
  }

  @override
  Future<List<Message>> getMoreMessages(
      String roomId, String lastFetchedMessageId) async {
    try {
      //print('last is ${_lastFetchedMessage!.data()}');
      List<Message> messages = [];
      final documentSnapshot = await _chats
          .doc(roomId)
          .collection('Messages')
          .doc(lastFetchedMessageId)
          .get();
      final querySnapshot = await _chats
          .doc(roomId)
          .collection('Messages')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(documentSnapshot)
          .limit(30)
          .get();

      for (var doc in querySnapshot.docs) {
        Message message = Message.fromJson(doc.data());
        messages.add(message);
      }

      return messages;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<GroupMessage>> getMoreGroupMessages(
      String roomId, String lastFetchedMessageId) async {
    try {
      List<GroupMessage> messages = [];
      final documentSnapshot = await _groupChats
          .doc(roomId)
          .collection('Messages')
          .doc(lastFetchedMessageId)
          .get();
      final querySnapshot = await _groupChats
          .doc(roomId)
          .collection('Messages')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(documentSnapshot)
          .limit(30)
          .get();

      for (var doc in querySnapshot.docs) {
        GroupMessage groupMessage = GroupMessage.fromJson(doc.data());
        messages.add(groupMessage);
      }

      return messages;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<ChatUserModel>> getFilteredContacts(int minAge, int maxAge, String gender, List<String> countries) async {
    try {
      List<ChatUserModel> chats = [];
      String chatCountries = SharedPref.getChatCountries();
      QuerySnapshot querySnapshot;

      if (gender.isEmpty || gender == 'gender') {
        if (countries.isEmpty)
          querySnapshot = chatCountries == 'All countries'
              ? await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .get()
              : await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .where('country', isEqualTo: chatCountries)
              .get();
        else
          querySnapshot = await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .where('country', whereIn: countries)
              .get();

      } else {
        if (countries.isEmpty)
          querySnapshot = chatCountries == 'All countries'
              ? await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .where('gender', isEqualTo: gender)
              .get()
              : await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .where('country', isEqualTo: chatCountries)
              .where('gender', isEqualTo: gender)
              .get();
        else
          querySnapshot = await _users
              .where('userType', isNotEqualTo: UserType.Guest.toString())
              .where('country', whereIn: countries)
              .where('gender', isEqualTo: gender)
              .get();
      }

      for(var doc in querySnapshot.docs){
        final data = doc.data() as Map<String, dynamic>;

        if(data['userId'] == SharedPref.getUser().id)
          continue;

        String dateBirth = data['dateBirth'] ?? '';
        int age = Helper().getAgeFromBirthDate(dateBirth);
        if((age > minAge && age < maxAge) || (minAge == 0 && maxAge == 100)){
          ChatUserModel chatUserModel = ChatUserModel.fromJson(data);
          chats.add(chatUserModel);
        }
      }


      return chats;
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }
}
