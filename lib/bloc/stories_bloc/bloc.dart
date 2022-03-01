import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/stories_repo/storiesRepository.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/model/story_model.dart';

class StoriesBloc extends Bloc<StoriesBlocEvents, StoriesBlocStates> {
  StroiesRepo _storiesReop = StroiesRepo();

  StoriesBloc() : super(StoriesBlocInitState()) {
    on<StoriesBlocEvents>((event, emit) async {
      if (event is FetchALLStories) {
        emit(FetchAllStoriesLoadingState());
        try {
          final data = await _storiesReop.FetchStories();
          StoriesModel model = StoriesModel.fromJson(data);
          emit(FetchAllStoriesDoneState(model));
        } catch (e) {
          print('error in fetch all stories' + e.toString());
          emit(FetchAllStoriesFailedState());
        }
      }

      if (event is AddStory) {
        emit(AddStroyLoadingState());

        try {
          await _storiesReop.addStory(
            pickedFile: event.Image,
            storyOwnerId: SharedPref.getUser().id!,
            storydesc: event.desc,
            storyOwnerImage: SharedPref.getUser().profileImage!,
            storyOwnername: SharedPref.getUser().userName! +
                ' ' +
                SharedPref.getUser().nickName!,
          );

          emit(AddStroyDoneState());
        } catch (e) {
          print('error');
          print(e.toString());
          emit(AddStroyFailedState());
        }
      }

      if (event is MakeStoryFavorite) {
        emit(MakeStroyFavoriteLoadingingState());
        try {
          await _storiesReop.setStoryFavorite(event.storyId, event.deleted);
          emit(MakeStroyFavoriteDoneState(event.storyId));
        } catch (e) {
          emit(MakeStroyFavoriteFailedState());
        }
      }
    });
  }
}
