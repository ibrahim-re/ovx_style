import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ovx_style/api/users/database_repository.dart';

import '../../model/chatUserModel.dart';
import '../../model/roomModel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  DatabaseRepositoryImpl _hand = DatabaseRepositoryImpl();
  ChatBloc() : super(GETAllChatInitial()) {
    on<ChatEvents>((event, emit) async {
      if (event is FetchAllChats) {
        emit(GETAllChatLoadingState());
        try {
          final data = await _hand.getAllUsers();
          ChatUsersModel model = ChatUsersModel.fromJson(data.docs);
          emit(GETAllChatDoneState(model));
        } catch (e) {
          print(e.toString());
          emit(GETAllChatFailedState('Opps, something went wrong'));
        }
      }

      if (event is createRoom) {
        emit(CreatedRoomLoadingState());
        try {
          final createdRoomId = await _hand.createRoom(
            event.myId,
            event.anotherUserId,
          );
          emit(CreatedRoomDoneState(createdRoomId, event.anotherUserId));
        } catch (e) {
          emit(CreatedRoomFailedState('error'));
        }
      }

      if (event is sendMessage) {
        await _hand.sendMessage(event.roomId, event.data);
      }

      if (event is FetchRoomMessages) {
        emit(GETChatMessageLoadingState());
        try {
          final data = await _hand.fetchRoom(event.roomId);
          final info = data['info'];
          final messages = data['messages'];

          final Map<String, dynamic> parsedData = {
            'RoomId': info['roomId'],
            'myId': info['loggedUserId'],
            'anotherUserId': info['anotherUserId'],
            'messages': messages,
          };

          final model = RoomModel.fromJson(parsedData);
          emit(GETChatMessageDoneState(model));
        } catch (e) {
          print(e.toString());
          emit(GETChatMessageFailedState('Error in Fetch Messages'));
        }
      }
    });
  }
}
