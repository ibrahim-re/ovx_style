import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/stories_repo/storiesRepository.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/model/story_model.dart';

class StoriesBloc extends Bloc<StoriesBlocEvents, StoriesBlocStates> {
  StroiesRepo _storiesReop = StroiesRepo();
  late StoriesModel storyModel;
  StoriesBloc() : super(StoriesBlocInitState()) {

    on<StoriesBlocEvents>((event, emit) async {
      if (event is FetchALLStories) {
        emit(FetchAllStoriesLoadingState());
        try {
          final data = await _storiesReop.FetchStories();
          storyModel = StoriesModel.fromJson(data);
          emit(FetchAllStoriesDoneState());
        } catch (e) {
          print('error in fetch all stories' + e.toString());
          emit(FetchAllStoriesFailedState('Error occurred, please try again'));
        }
      }

      if (event is AddStory) {
        emit(AddStoryLoadingState());

        try {
          await _storiesReop.addStory(
            pickedFiles: event.images,
            storyOwnerId: SharedPref.getUser().id!,
            storydesc: event.desc,
            storyOwnerImage: SharedPref.getUser().profileImage!,
            storyOwnername: SharedPref.getUser().userName!,
          );

          emit(AddStoryDoneState());
        } catch (e) {
          print('error');
          print(e.toString());
          emit(AddStoryFailedState('error occurred'.tr()));
        }
      }

      if (event is MakeStoryFavorite) {
        emit(MakeStoryFavoriteLoadingState());
        try {
          await _storiesReop.setStoryFavorite(event.storyId, event.deleted);
          emit(MakeStoryFavoriteDoneState(event.storyId));
        } catch (e) {
          emit(MakeStoryFavoriteFailedState());
        }
      }

      else if(event is DeleteStory){
        emit(DeleteStoryLoading());
        try{
          await _storiesReop.deleteStory(event.storyId, event.imageUrls);
          emit(DeleteStorySucceed());
        }catch (e){
          emit(DeleteStoryFailed('error occurred'.tr()));
        }
      }
    });
  }
}
