import 'dart:io';

abstract class StoriesBlocEvents {}

class FetchALLStories extends StoriesBlocEvents {}

class AddStory extends StoriesBlocEvents {
  final File Image;

  AddStory(this.Image);
}
