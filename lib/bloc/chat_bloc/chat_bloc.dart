import 'package:bloc/bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';

import '../../model/chatUserModel.dart';
import '../../model/roomModel.dart';
import 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  late ChatUsersModel contactsModel = ChatUsersModel(allChats: []);
  late ChatUsersModel chatsModel = ChatUsersModel(allChats: []);
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
      else if(event is GetUserChats){
        emit(GetUserChatsLoading());
        try{
          chatsModel = await _hand.getChats(event.userId);
          emit(GetUserChatsDone());
        }catch(e){
          emit(GetUserChatsFailed('error occurred'.tr()));
        }
      }
      else if (event is CreateRoom) {
        emit(CreatedRoomLoadingState());
        try {
          String myId = SharedPref.getUser().id!;
          String anotherUserID = event.firstUserId == myId ? event.secondUserId : event.firstUserId;
          String roomId = await _hand.checkIfRoomExists(event.firstUserId, event.secondUserId);

          if(roomId.isNotEmpty){
            emit(CreatedRoomDoneState(roomId, anotherUserID));
          }

          else {
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

      if (event is SendMessage) {
        try {
          await _hand.sendMessage(event.roomId, event.message);
        } catch (e) {
          emit(SendMessageFailed('failed to send message'.tr()));
        }
      }

      if (event is FetchRoomMessages) {
        emit(GETChatMessageLoadingState());
        try {
          final data = await _hand.fetchRoom(event.roomId);
          final info = data['info'];
          final messages = data['messages'];

          final Map<String, dynamic> parsedData = {
            'RoomId': info['roomId'],
            'firstUserId': info['firstUserId'],
            'secondUserId': info['secondUserId'],
            'messages': messages,
          };

          final model = RoomModel.fromJson(parsedData);
          emit(GETChatMessageDoneState(model));
        } catch (e) {
          print(e.toString());
          emit(GETChatMessageFailedState('Error in Fetch Messages'));
        }
      }

      if (event is UploadeImageToRoom) {
        emit(UploadeImageToRoomLoadingState());
        try {
          final String url =
              await _hand.uploadeImagetoRoom(event.roomId, event.Image);
          emit(UploadeImageToRoomDoneState(url));
        } catch (e) {
          emit(UploadeImageToRoomFailedState('Failed sending Image !!'));
        }
      }
    });
  }
}
