import 'dart:io';

import 'package:ovx_style/bloc/stories_bloc/states.dart';

abstract class StoriesBlocEvents {}

class FetchALLStories extends StoriesBlocEvents {}

class FetchMoreStories extends StoriesBlocEvents {
  String lastFetchedStoryId;

  FetchMoreStories(this.lastFetchedStoryId);
}

class AddStory extends StoriesBlocEvents {
  final List<File> images;
  final String desc;

  AddStory(this.images, this.desc);
}

class MakeStoryFavorite extends StoriesBlocEvents {
  final String storyId;
  final bool deleted;
  MakeStoryFavorite(this.storyId, this.deleted);
}

class DeleteStory extends StoriesBlocEvents {
  String storyId;
  List<String> imageUrls;

  DeleteStory(this.storyId, this.imageUrls);
}

class FilterStories extends StoriesBlocEvents {}
