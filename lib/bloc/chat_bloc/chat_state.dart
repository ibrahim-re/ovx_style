import 'package:ovx_style/model/group_model.dart';

import '../../model/chatUserModel.dart';
import '../../model/message_model.dart';

abstract class ChatStates {}

class ChatInitial extends ChatStates {}

//get contacts
class GetContactsLoading extends ChatStates {}

class GetContactsDone extends ChatStates {}

class GetContactsFailed extends ChatStates {
  final String err;
  GetContactsFailed(this.err);
}

//get chats
class GetUserChatsLoading extends ChatStates {}

class GetUserChatsDone extends ChatStates {}

class GetUserChatsFailed extends ChatStates {
  final String err;
  GetUserChatsFailed(this.err);
}

//create room
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

class CreateGroupLoading extends ChatStates {}

class CreateGroupDone extends ChatStates {
  GroupModel groupModel;

  CreateGroupDone(this.groupModel);
}

class CreateGroupFailed extends ChatStates {
  String message;

  CreateGroupFailed(this.message);
}

class GetGroupsLoading extends ChatStates {}

class GetGroupsDone extends ChatStates {}

class GetGroupsFailed extends ChatStates {
  String message;
  GetGroupsFailed(this.message);
}

//send message
class SendMessageFailed extends ChatStates {
  String message;
  SendMessageFailed(this.message);
}

// uploade image to room

class UploadeImageToRoomLoadingState extends ChatStates {}

class UploadeImageToRoomDoneState extends ChatStates {
  final String imageUrl;
  UploadeImageToRoomDoneState(this.imageUrl);
}

class UploadeImageToRoomFailedState extends ChatStates {
  final String err;
  UploadeImageToRoomFailedState(this.err);
}

// send voice

class SendVoiceLoading extends ChatStates {
  SendVoiceLoading();
}

class SendVoiceFailed extends ChatStates {
  String message;
  SendVoiceFailed(this.message);
}
