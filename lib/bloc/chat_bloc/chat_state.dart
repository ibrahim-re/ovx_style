part of 'chat_bloc.dart';

@immutable
abstract class ChatStates {}

class GETAllChatInitial extends ChatStates {}

class GETAllChatLoadingState extends ChatStates {}

class GETAllChatDoneState extends ChatStates {
  final ChatUsersModel model;
  GETAllChatDoneState(this.model);
}

class GETAllChatFailedState extends ChatStates {
  final String err;
  GETAllChatFailedState(this.err);
}

// created room

class CreatedRoomLoadingState extends ChatStates {}

class CreatedRoomDoneState extends ChatStates {
  final String roomId;
  final String anotherUserId;

  CreatedRoomDoneState(this.roomId, this.anotherUserId);
}

class CreatedRoomFailedState extends ChatStates {
  final String err;
  CreatedRoomFailedState(this.err);
}

// fetch room messages states

class GETChatMessageLoadingState extends ChatStates {}

class GETChatMessageDoneState extends ChatStates {
  final RoomModel model;
  GETChatMessageDoneState(this.model);
}

class GETChatMessageFailedState extends ChatStates {
  final String err;
  GETChatMessageFailedState(this.err);
}