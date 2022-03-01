import 'dart:io';

abstract class StoriesBlocEvents {}

class FetchALLStories extends StoriesBlocEvents {}

class AddStory extends StoriesBlocEvents {
  final File Image;
  final String desc;

  AddStory(this.Image, this.desc);
}

class MakeStoryFavorite extends StoriesBlocEvents {
  final String storyId;
  final bool deleted;
  MakeStoryFavorite(this.storyId, this.deleted);
}
