import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/story/widgets/story.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';
import 'package:ovx_style/model/story_model.dart';

class StoriesGridView extends StatefulWidget {
  final List<StoryModel> stories;
  final scrollController;
  final child;

  StoriesGridView({required this.stories, this.scrollController, this.child});

  @override
  State<StoriesGridView> createState() => _StoriesGridViewState();
}

class _StoriesGridViewState extends State<StoriesGridView> {
  TextEditingController descCon = TextEditingController();

  @override
  void dispose() {
    descCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              ModalSheets().showFilter(context, CountriesFor.Story);
            },
            icon: SvgPicture.asset('assets/images/filter.svg'),
          ),
        ],
      ),
      body: widget.stories.isNotEmpty
          ? RefreshIndicator(
              color: MyColors.secondaryColor,
              onRefresh: () async {
                BlocProvider.of<StoriesBloc>(context).add(FetchALLStories());
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      controller: widget.scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      padding: const EdgeInsets.only(
                        bottom: 24,
                        left: 14,
                        right: 14,
                        top: 14,
                      ),
                      children: widget.stories.map((item) {
                        return GestureDetector(
                          onTap: () {
                            NamedNavigatorImpl().push(
                                NamedRoutes.StoryDetailsScreen,
                                arguments: {"oneStory": item});
                          },
                          child: Story(model: item),
                        );
                      }).toList(),
                    ),
                  ),
                  widget.child ?? Container(),
                ],
              ))
          : Center(
              child: Text(
                'no story yet'.tr(),
                style: Constants.TEXT_STYLE9,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.secondaryColor,
        child: SvgPicture.asset('assets/images/add_story.svg'),
        onPressed: () async {
          final imageSource = await PickImageHelper().showPicker(context);
          if (imageSource == null) return;
          List<File> pickedFiles = [];

          if (imageSource == ImageSource.camera) {
            File file = await PickImageHelper().pickImageFromSource(imageSource);
            pickedFiles.add(file);
          } else {
            pickedFiles = await PickImageHelper().pickMultiImages();
          }

          if (await pickedFiles.isNotEmpty)
            ModalSheets().showStoryDescSheet(context, descCon, pickedFiles);
        },
      ),
    );
  }
}
