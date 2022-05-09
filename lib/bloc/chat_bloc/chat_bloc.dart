import 'package:bloc/bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/chats/chats_repository.dart';
import 'package:ovx_style/api/packags/packages_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/group_model.dart';
import '../../model/chatUserModel.dart';
import '../../model/message_model.dart';
import 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  List<ChatUserModel> contactsModel = [];
  List<ChatUserModel> chatsModel = [];
  List<GroupModel> groups = [];
  ChatsRepositoryImpl _chatRepositoryImpl = ChatsRepositoryImpl();
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
  PackagesRepositoryImpl _packagesRepositoryImpl = PackagesRepositoryImpl();


  //for filter
  int minAge = 0;
  int maxAge = 100;
  String gender = '';
  List<String> filterCountries = [];

  resetFilter(){
    minAge = 0;
    maxAge = 100;
    gender = '';
    filterCountries = [];
  }


  ChatBloc() : super(ChatInitial()) {
    on<ChatEvents>((event, emit) async {
      if (event is GetContacts) {
        emit(GetContactsLoading());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0)
            emit(GetContactsFailed('no available days'.tr()));
          else{
            contactsModel = await _chatRepositoryImpl.getContacts();
            emit(GetContactsDone());
          }
        } catch (e) {
          print(e.toString());
          emit(GetContactsFailed('error occurred'.tr()));
        }
      }
      else if (event is GetUserChats) {
        emit(GetUserChatsLoading());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0)
            emit(GetUserChatsFailed('no available days'.tr()));
          else {
            chatsModel = await _chatRepositoryImpl.getChats(event.userId);
            emit(GetUserChatsDone());
          }
        } catch (e) {
          print('error is $e');
          emit(GetUserChatsFailed('error occurred'.tr()));
        }
      }
      else if (event is CreateRoom) {
        emit(CreatedRoomLoadingState());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0)
            emit(CreatedRoomFailedState('no available days'.tr()));
          else{
            String myId = SharedPref.getUser().id!;
            String anotherUserID = event.firstUserId == myId
                ? event.secondUserId
                : event.firstUserId;
            String roomId = await _chatRepositoryImpl.checkIfRoomExists(
                event.firstUserId, event.secondUserId);

            if (roomId.isNotEmpty) {
              emit(CreatedRoomDoneState(roomId, anotherUserID));
            } else {
              final createdRoomId = await _chatRepositoryImpl.createRoom(
                event.firstUserId,
                event.secondUserId,
              );
              emit(CreatedRoomDoneState(createdRoomId, anotherUserID));
            }
          }
        } catch (e) {
          emit(CreatedRoomFailedState('error occurred'.tr()));
        }
      }
      else if (event is SendMessage) {
        try {
          if (event.chatType == ChatType.Chat)
            await _chatRepositoryImpl.sendMessage(event.roomId, event.message);
          else {
            GroupMessage groupMessage = GroupMessage(
              msgValue: event.message,
              readBy: [],
              sender: SharedPref.getUser().id,
              msgType: 0,
              createdAt: DateTime.now(),
              senderImage: SharedPref.getUser().profileImage,
              senderName: SharedPref.getUser().userName,
            );
            await _chatRepositoryImpl.sendGroupMessage(event.roomId, groupMessage);
          }
        } catch (e) {
          emit(SendMessageFailed('failed to send message'.tr()));
        }
      }
      else if (event is SendVoice) {
        emit(SendVoiceLoading());
        try {
          await _chatRepositoryImpl.sendVoice(event.roomId, event.message, event.chatType);
          emit(SendVoiceDone());
        } catch (e) {
          emit(SendVoiceFailed('failed to send message'.tr()));
        }
      }
      else if (event is UploadImageToRoom) {
        emit(UploadImageToRoomLoadingState());
        try {
          final String url = await _chatRepositoryImpl.uploadImageToRoom(event.roomId, event.Image, event.chatType);
          emit(UploadImageToRoomDoneState(url));
        } catch (e) {
          emit(UploadImageToRoomFailedState('Failed sending Image !!'));
        }
      }
      else if (event is CreateGroup) {
        emit(CreateGroupLoading());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0)
            emit(CreateGroupFailed('no available days'.tr()));
          else{
            await _databaseRepositoryImpl.removePoints(150, SharedPref.getUser().id!);
            await _chatRepositoryImpl.createGroup(event.groupModel);
            emit(CreateGroupDone(event.groupModel));
          }
        } catch (e) {
          print(e);
          emit(CreateGroupFailed('error occurred'.tr()));
        }
      }
      else if (event is GetGroups) {
        emit(GetGroupsLoading());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0)
            emit(GetGroupsFailed('no available days'.tr()));
          else {
            groups = await _chatRepositoryImpl.getGroups(SharedPref.getUser().id!);
            emit(GetGroupsDone());
          }
        } catch (e) {
          emit(GetGroupsFailed('error occurred'.tr()));
        }
      }
      else if(event is GetMoreMessages){
        emit(GetMoreMessagesLoading());
        try{
          List<Message> messages = await _chatRepositoryImpl.getMoreMessages(event.roomId, event.lastFetchedMessageId);
          emit(GetMoreMessagesDone(messages));
        }catch(e){
          print('error is $e');
          emit(GetMoreMessagesFailed('error occurred'.tr()));
        }
      }
      else if(event is GetMoreGroupMessages){
        emit(GetMoreGroupMessagesLoading());
        try{
          List<GroupMessage> messages = await _chatRepositoryImpl.getMoreGroupMessages(event.groupId, event.lastFetchedMessageId);
          emit(GetMoreGroupMessagesDone(messages));
        }catch(e){
          print('error is $e');
          emit(GetMoreGroupMessagesFailed('error occurred'.tr()));
        }
      }
      else if (event is FilterChats) {
        emit(GetContactsLoading());
        try {
          int availableDays = await _packagesRepositoryImpl.getChatAvailableDays();
          if(availableDays == 0) {
            resetFilter();
            emit(GetContactsFailed('no available days'.tr()));
          }
          else{
            contactsModel = await _chatRepositoryImpl.getFilteredContacts(minAge, maxAge, gender, filterCountries);
            resetFilter();
            emit(GetContactsDone());
          }
        } catch (e) {
          resetFilter();
          print(e.toString());
          emit(GetContactsFailed('error occurred'.tr()));
        }
      }
    });
  }
}
