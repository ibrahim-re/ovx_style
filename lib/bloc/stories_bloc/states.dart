import '../../model/story_model.dart';

abstract class StoriesBlocStates {}

class StoriesBlocInitState extends StoriesBlocStates {}

class FetchAllStoriesLoadingState extends StoriesBlocStates {}

class FetchAllStoriesDoneState extends StoriesBlocStates {}

class FetchAllStoriesFailedState extends StoriesBlocStates {
  String message;

  FetchAllStoriesFailedState(this.message);
}

class FetchMoreStoriesLoading extends StoriesBlocStates {}

class FetchMoreStoriesDone extends StoriesBlocStates {}

class FetchMoreStoriesFailed extends StoriesBlocStates {
  String message;

  FetchMoreStoriesFailed(this.message);
}

class AddStoryLoadingState extends StoriesBlocStates {}

class AddStoryDoneState extends StoriesBlocStates {
  int storyCountAvailable;

  AddStoryDoneState(this.storyCountAvailable);
}

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

class FilterStoriesLoading extends StoriesBlocStates {}

class FilterStoriesDone extends StoriesBlocStates {
  List<StoryModel> stories;

  FilterStoriesDone(this.stories);
}

class FilterStoriesFailed extends StoriesBlocStates {
  String message;

  FilterStoriesFailed(this.message);
}