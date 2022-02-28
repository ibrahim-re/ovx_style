import '../../model/story_model.dart';

abstract class StoriesBlocStates {}

class StoriesBlocInitState extends StoriesBlocStates {}

class FetchAllStoriesLoadingState extends StoriesBlocStates {}

class FetchAllStoriesDoneState extends StoriesBlocStates {
  final StoriesModel model;
  FetchAllStoriesDoneState(this.model);
}

class FetchAllStoriesFailedState extends StoriesBlocStates {}

class AddStroyLoadingState extends StoriesBlocStates {}

class AddStroyDoneState extends StoriesBlocStates {}

class AddStroyFailedState extends StoriesBlocStates {}
