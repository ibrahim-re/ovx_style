import 'package:bloc/bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/group_model.dart';
import '../../model/chatUserModel.dart';
import '../../model/message_model.dart';
import 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  late ChatUsersModel contactsModel = ChatUsersModel(allChats: []);
  late ChatUsersModel chatsModel = ChatUsersModel(allChats: []);
  List<GroupModel> groups = [];
  DatabaseRepositoryImpl _hand = DatabaseRepositoryImpl();
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvents>((event, emit) async {
      if (event is GetContacts) {
        emit(GetContactsLoading());
        try {
          final data = await _hand.GetContacts();
          contactsModel = ChatUsersModel.fromJson(data.docs);
          emit(GetContactsDone());
        } catch (e) {
          print(e.toString());
          emit(GetContactsFailed('Opps, something went wrong'));
        }
      }
      else if (event is GetUserChats) {
      }
      else if (event is GetUserChats) {
        emit(GetUserChatsLoading());
        try {
          chatsModel = await _hand.getChats(event.userId);
          emit(GetUserChatsDone());
        } catch (e) {
          print('error is $e');
          emit(GetUserChatsFailed('error occurred'.tr()));
        }
      }
      else if (event is CreateRoom) {
        emit(CreatedRoomLoadingState());
        try {
          String myId = SharedPref.getUser().id!;
          String anotherUserID = event.firstUserId == myId
              ? event.secondUserId
              : event.firstUserId;
          String roomId = await _hand.checkIfRoomExists(
              event.firstUserId, event.secondUserId);

          if (roomId.isNotEmpty) {
            emit(CreatedRoomDoneState(roomId, anotherUserID));
          } else {
            final createdRoomId = await _hand.createRoom(
              event.firstUserId,
              event.secondUserId,
            );
            emit(CreatedRoomDoneState(createdRoomId, anotherUserID));
          }
        } catch (e) {
          emit(CreatedRoomFailedState('error'));
        }
      }
      else if (event is SendMessage) {
        try {
          if (event.chatType == ChatType.Chat)
            await _hand.sendMessage(event.roomId, event.message);
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
            await _hand.sendGroupMessage(event.roomId, groupMessage);
          }
        } catch (e) {
          emit(SendMessageFailed('failed to send message'.tr()));
        }
      }

      if (event is SendVoice) {
        emit(SendVoiceLoading());
        try {
          await _hand.sendVoice(event.roomId, event.message);
        } catch (e) {
          emit(SendVoiceFailed('failed to send message'.tr()));
        }
      }

      if (event is UploadImageToRoom) {
        emit(UploadeImageToRoomLoadingState());
        try {
          final String url =
              await _hand.uploadeImagetoRoom(event.roomId, event.Image);
          emit(UploadeImageToRoomDoneState(url));
        } catch (e) {
          emit(UploadeImageToRoomFailedState('Failed sending Image !!'));
        }
      }
      else if (event is CreateGroup) {
        emit(CreateGroupLoading());
        try {
          await _hand.createGroup(event.groupModel);
          emit(CreateGroupDone(event.groupModel));
        } catch (e) {
          print(e);
          emit(CreateGroupFailed('error occurred'.tr()));
        }
      }
      else if (event is GetGroups) {
        emit(GetGroupsLoading());
        try {
          groups = await _hand.getGroups(SharedPref.getUser().id!);
          emit(GetGroupsDone());
        } catch (e) {
          emit(CreateGroupFailed('error occurred'.tr()));
        }
      }
    });
  }
}
