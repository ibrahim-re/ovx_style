import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/packags/packages_repository.dart';
import 'package:ovx_style/api/stories/stories_repository.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/story_model.dart';
import 'package:ovx_style/model/user.dart';

class StoriesBloc extends Bloc<StoriesBlocEvents, StoriesBlocStates> {
  StoriesRepo _storiesRepo = StoriesRepo();
  PackagesRepositoryImpl _packagesRepositoryImpl = PackagesRepositoryImpl();
  List<StoryModel> stories = [];

  //in case many requests sent at same time
  bool _alreadyFetchingMoreStories = false;

  //for filter
  int minAge = 0;
  int maxAge = 100;
  String gender = '';
  List<String> filterCountries = [];

  resetFilter(){
    minAge = 0;
    maxAge = 100;
    gender = '';
    filterCountries = [];
  }

  StoriesBloc() : super(StoriesBlocInitState()) {
    on<StoriesBlocEvents>((event, emit) async {
      if (event is FetchALLStories) {
        emit(FetchAllStoriesLoadingState());
        try {
          int availableDays = await _packagesRepositoryImpl.getStoryAvailableDays();
          if (availableDays == 0)
            emit(FetchAllStoriesFailedState('no available days'.tr()));
          else {
            stories = await _storiesRepo.FetchStories();
            emit(FetchAllStoriesDoneState());
          }
        } catch (e) {
          print('error in fetch all stories' + e.toString());
          emit(FetchAllStoriesFailedState('error occurred'.tr()));
        }
      } else if (event is FetchMoreStories && !_alreadyFetchingMoreStories) {
        _alreadyFetchingMoreStories = true;
        emit(FetchMoreStoriesLoading());
        print('last from here is ${event.lastFetchedStoryId}');
        try {
          List<StoryModel> moreStories = await _storiesRepo.FetchStories(
              lastFetchedStoryId: event.lastFetchedStoryId);
          stories.addAll(moreStories);
          _alreadyFetchingMoreStories = false;
          emit(FetchMoreStoriesDone());
        } catch (e) {
          print('error in fetch all stories' + e.toString());
          _alreadyFetchingMoreStories = false;
          emit(FetchMoreStoriesFailed('error occurred'.tr()));
        }
      }

      if (event is AddStory) {
        emit(AddStoryLoadingState());
        try {
          int storyCount = await _packagesRepositoryImpl.getStoryCountAvailable();
          if(storyCount == 0){
            emit(AddStoryFailedState('no story count'.tr()));
          }else{
            final user = SharedPref.getUser();
            String gender = '';
            int age = 0;
            if(user.userType == UserType.User.toString()){
              gender = (user as PersonUser).gender ?? '';
              age = Helper().getAgeFromBirthDate(user.dateBirth ?? '');
            }

            StoryModel story = await _storiesRepo.addStory(
              pickedFiles: event.images,
              storyOwnerId: user.id!,
              storyOwnerCountry: user.country!,
              storyDesc: event.desc,
              storyOwnerImage: user.profileImage!,
              storyOwnerName: user.userName!,
              gender: gender,
              age: age,
            );

            stories.insert(0, story);
            await _packagesRepositoryImpl.updateStoryCountAvailable();
            emit(AddStoryDoneState(storyCount - 1));
          }
        } catch (e) {
          print('error');
          print(e.toString());
          emit(AddStoryFailedState('error occurred'.tr()));
        }
      }

      if (event is MakeStoryFavorite) {
        emit(MakeStoryFavoriteLoadingState());
        try {
          await _storiesRepo.setStoryFavorite(event.storyId, event.deleted);
          emit(MakeStoryFavoriteDoneState(event.storyId));
        } catch (e) {
          emit(MakeStoryFavoriteFailedState());
        }
      } else if (event is DeleteStory) {
        emit(DeleteStoryLoading());
        try {
          await _storiesRepo.deleteStory(event.storyId, event.imageUrls);
          emit(DeleteStorySucceed());
        } catch (e) {
          emit(DeleteStoryFailed('error occurred'.tr()));
        }
      } else if (event is FilterStories) {
        emit(FilterStoriesLoading());
        try {
          List<StoryModel> filteredStories = await _storiesRepo.getFilteredStories(minAge, maxAge, gender, filterCountries);
          resetFilter();
          emit(FilterStoriesDone(filteredStories));
        } catch (e) {
          resetFilter();
          print(e.toString());
          emit(FilterStoriesFailed('error occurred'.tr()));
        }
      }
    });
  }
}
