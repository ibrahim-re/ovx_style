import '../../model/story_model.dart';

abstract class StoriesBlocStates {}

class StoriesBlocInitState extends StoriesBlocStates {}

class FetchAllStoriesLoadingState extends StoriesBlocStates {}

class FetchAllStoriesDoneState extends StoriesBlocStates {}

class FetchAllStoriesFailedState extends StoriesBlocStates {
  String message;

  FetchAllStoriesFailedState(this.message);
}

class AddStoryLoadingState extends StoriesBlocStates {}

class AddStoryDoneState extends StoriesBlocStates {}

class AddStoryFailedState extends StoriesBlocStates {
  String message;

  AddStoryFailedState(this.message);
}

class MakeStoryFavoriteLoadingState extends StoriesBlocStates {}

class MakeStoryFavoriteDoneState extends StoriesBlocStates {
  final String storyId;
  MakeStoryFavoriteDoneState(this.storyId);
}

class MakeStoryFavoriteFailedState extends StoriesBlocStates {}

class DeleteStoryLoading extends StoriesBlocStates {}

class DeleteStorySucceed extends StoriesBlocStates {}

class DeleteStoryFailed extends StoriesBlocStates {
  String message;

  DeleteStoryFailed(this.message);
}