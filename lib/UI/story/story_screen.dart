import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/story/widgets/slider.dart';
import 'package:ovx_style/UI/story/widgets/story.dart';
import 'package:ovx_style/UI/widgets/no_permession_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/modal_sheets.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/helper/pick_image_helper.dart';
import 'package:ovx_style/model/story_model.dart';

class StoryScreen extends StatefulWidget {
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TextEditingController descCon = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<StoriesBloc>(context).add(FetchALLStories());
    super.initState();
  }

  @override
  void dispose() {
    descCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //no Story available for companies
    if (SharedPref.getUser().userType == UserType.Company.toString())
      return Center(
        child: NoDataWidget(
          text: 'Story is not available for companies',
          iconName: 'story',
        ),
      );
    else
      return BlocConsumer<StoriesBloc, StoriesBlocStates>(
        listener: (ctx, state) {
          if (state is AddStoryLoadingState || state is DeleteStoryLoading)
            EasyLoading.show(status: 'please wait'.tr());
          else if (state is AddStoryFailedState)
            EasyLoading.showError(state.message);
          else if (state is AddStoryDoneState)
            EasyLoading.showSuccess('story added'.tr());
          else if (state is DeleteStorySucceed)
            EasyLoading.showSuccess('story deleted'.tr());
          else if (state is DeleteStoryFailed)
            EasyLoading.showError(state.message);
        },
        builder: (ctx, state) {
          if (state is FetchAllStoriesLoadingState ||
              state is StoriesBlocInitState)
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ),
            );
          else if (state is FetchAllStoriesFailedState)
            return Center(
              child: Text(
                state.message,
                style: Constants.TEXT_STYLE9,
              ),
            );
          else {
            StoriesModel stories = context.read<StoriesBloc>().storyModel;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Stories'.tr(),
                ),
              ),
              body: RefreshIndicator(
                color: MyColors.secondaryColor,
                onRefresh: () async {
                  BlocProvider.of<StoriesBloc>(context).add(FetchALLStories());
                },
                child: GridView.count(
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
                  children: stories.allStories.map((item) {
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
              floatingActionButton: FloatingActionButton(
                backgroundColor: MyColors.secondaryColor,
                child: SvgPicture.asset('assets/images/add_story.svg'),
                onPressed: () async {
                  final imageSource =
                      await PickImageHelper().showPicker(context);
                  if (imageSource == null) return;
                  List<File> pickedFiles = [];

                  if (imageSource == ImageSource.camera) {
                    File file = await PickImageHelper()
                        .pickImageFromSource(imageSource);
                    pickedFiles.add(file);
                  } else {
                    pickedFiles = await PickImageHelper().pickMultiImages();
                  }

                  if (await pickedFiles.isNotEmpty)
                    ModalSheets()
                        .showStoryDescSheet(context, descCon, pickedFiles);
                },
              ),
            );
          }
        },
      );
  }
}

/*Form(
                        child: SingleChildScrollView(
                          child: AnimatedPadding(
                            padding: MediaQuery.of(context).viewPadding,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.decelerate,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text('story desc'),
                                SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: descCon,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Story Descreption',
                                      hintStyle:
                                      TextStyle(color: MyColors.grey),
                                      enabled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: MyColors.secondaryColor,
                                        ),
                                      ),
                                    ),
                                    onFieldSubmitted: (String val) {
                                      if (val.isNotEmpty) {
                                        Navigator.of(context).pop();
                                        BlocProvider.of<StoriesBloc>(context)
                                            .add(
                                          AddStory(
                                            pickedFile,
                                            descCon.text.trim(),
                                          ),
                                        );
                                        descCon.clear();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )*/
void showFilterSheet({required BuildContext context}) {
  showModalBottomSheet(
      context: context,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: MyColors.primaryColor,
        ),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Age'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              storySliderItem(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showCountriesSheet(context: context);
                },
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    suffixIcon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    hintText: 'Countries'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                enabled: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  prefixIcon: Icon(Icons.person),
                  enabled: true,
                  suffixIcon: PopupMenuButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    offset: Offset(-10, 40),
                    padding: const EdgeInsets.all(0),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 6,
                            right: 10,
                          ),
                          height: 4,
                          onTap: () {},
                          child: Text('Male'),
                        ),
                        PopupMenuItem(
                          padding: const EdgeInsets.only(
                            left: 10,
                            bottom: 6,
                            right: 10,
                          ),
                          height: 4,
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            child: Text('Female'),
                          ),
                        ),
                      ];
                    },
                  ),
                  hintText: 'Gender'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              applyButton(onTap: () {}),
            ],
          ),
        );
      });
}

void showCountriesSheet({required BuildContext context}) {
  showModalBottomSheet(
      context: context,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        borderSide: BorderSide(
          color: MyColors.primaryColor,
        ),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shipping Countries ',
                style: TextStyle(
                  color: MyColors.secondaryColor,
                ),
              ),
            ],
          ),
        );
      });
}

void showGenderList() {
  PopupMenuButton(itemBuilder: (_) {
    return [
      PopupMenuItem(child: Text('Male')),
      PopupMenuItem(child: Text('FeMale')),
    ];
  });
}

Widget applyButton({required Function onTap}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.all(14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          'Apply'.toUpperCase().tr(),
          style: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 18,
          ),
        )),
  );
}
