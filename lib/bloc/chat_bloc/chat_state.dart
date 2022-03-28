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

class UploadImageToRoomLoadingState extends ChatStates {}

class UploadImageToRoomDoneState extends ChatStates {
  final String imageUrl;
  UploadImageToRoomDoneState(this.imageUrl);
}

class UploadImageToRoomFailedState extends ChatStates {
  final String message;
  UploadImageToRoomFailedState(this.message);
}

// send voice

class SendVoiceLoading extends ChatStates {}

class SendVoiceDone extends ChatStates {}

class SendVoiceFailed extends ChatStates {
  String message;
  SendVoiceFailed(this.message);
}

class GetMoreMessagesLoading extends ChatStates {}

class GetMoreMessagesDone extends ChatStates {
  List<Message> messages;

  GetMoreMessagesDone(this.messages);
}

class GetMoreMessagesFailed extends ChatStates {
  String message;

  GetMoreMessagesFailed(this.message);
}

class GetMoreGroupMessagesLoading extends ChatStates {}

class GetMoreGroupMessagesDone extends ChatStates {
  List<GroupMessage> messages;

  GetMoreGroupMessagesDone(this.messages);
}

class GetMoreGroupMessagesFailed extends ChatStates {
  String message;

  GetMoreGroupMessagesFailed(this.message);
}
