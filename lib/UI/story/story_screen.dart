import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/story/widgets/stories_grid_view.dart';
import 'package:ovx_style/UI/widgets/guest_sign_widget.dart';
import 'package:ovx_style/UI/widgets/no_available_days_widget.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/model/story_model.dart';

class StoryScreen extends StatefulWidget {
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final scrollController = ScrollController();
  String _lastFetchedStoryId = '';
  String? userType;

  @override
  void initState() {
    userType = SharedPref.getUser().userType;
    if (userType != UserType.Guest.toString())
      BlocProvider.of<StoriesBloc>(context).add(FetchALLStories());

    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        context.read<StoriesBloc>().add(FetchMoreStories(_lastFetchedStoryId));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //no Story available for guests
    if (userType == UserType.Guest.toString())
      return Center(
        child: NoDataWidget(
          text: 'story is not available for guests'.tr(),
          iconName: 'story',
          child: GuestSignWidget(),
        ),
      );
    else
      return BlocConsumer<StoriesBloc, StoriesBlocStates>(
        listener: (ctx, state){
          if(state is AddStoryLoadingState)
            EasyLoading.show(status: 'please wait'.tr());
          else if(state is AddStoryFailedState){
            EasyLoading.dismiss();
            EasyLoading.showError(state.message);
          }
          else if(state is AddStoryDoneState){
            EasyLoading.dismiss();
            EasyLoading.showSuccess('${'story added'.tr()}\n${'stories available'.tr()}: ${state.storyCountAvailable}');
          }
        },
        builder: (ctx, state) {
          if (state is FetchAllStoriesLoadingState ||
              state is StoriesBlocInitState ||
              state is FilterStoriesLoading)
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ),
            );
          else if (state is FetchAllStoriesFailedState) {
            if (state.message == 'no available days'.tr())
              return NoAvailableDaysWidget();
            else
              return Center(
                child: Text(
                  state.message,
                  style: Constants.TEXT_STYLE9,
                  textAlign: TextAlign.center,
                ),
              );
          } else if (state is FilterStoriesFailed)
            return Center(
              child: Text(
                state.message,
                style: Constants.TEXT_STYLE9,
                textAlign: TextAlign.center,
              ),
            );
          else if (state is FilterStoriesDone)
            return StoriesGridView(stories: state.stories);
          else {
            List<StoryModel> stories = context.read<StoriesBloc>().stories;
            if (stories.isNotEmpty)
              _lastFetchedStoryId = stories.last.storyId ?? '';

            return StoriesGridView(
              stories: stories,
              scrollController: scrollController,
              child: state is FetchMoreStoriesLoading
                  ? Center(
                      child: RefreshProgressIndicator(
                        color: MyColors.secondaryColor,
                      ),
                    )
                  : state is FetchMoreStoriesFailed
                      ? Center(child: Text('error occurred'.tr()))
                      : Container(),
            );
          }
        },
      );
  }
}
