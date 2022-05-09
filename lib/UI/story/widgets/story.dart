import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/model/story_model.dart';

class Story extends StatelessWidget {
  Story({Key? key, required this.model}) : super(key: key);

  final StoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FadeInImage(
              imageErrorBuilder: (_, g, d) {
                return Image(
                  image: AssetImage('assets/images/no_internet.png'),
                );
              },
              placeholder: Image(
                image: AssetImage('assets/images/loader-animation.gif'),
              ).image,
              image: Image(
                image: NetworkImage(model.storyUrls!.first),
              ).image,
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Positioned(
              right: 1,
              child: IconButton(
                splashRadius: 5,
                onPressed: () {
                  BlocProvider.of<StoriesBloc>(context).add(
                    MakeStoryFavorite(
                      model.storyId!,
                      model.likedBy.contains(SharedPref.getUser().id),
                    ),
                  );
                },
                icon: BlocConsumer<StoriesBloc, StoriesBlocStates>(
                  listener: (context, state) {
                    if (state is MakeStoryFavoriteDoneState) {
                      if (state.storyId == model.storyId) {
                        if (model.likedBy.contains(SharedPref.getUser().id)) {
                          model.likedBy.removeWhere(
                            (element) => element == SharedPref.getUser().id,
                          );
                        } else {
                          model.likedBy.add(SharedPref.getUser().id);
                        }
                      }
                    }
                  },
                  builder: (context, state) {
                    return model.likedBy.contains(SharedPref.getUser().id)
                        ? SvgPicture.asset(
                            'assets/images/heart.svg',
                            color: MyColors.red,
                          )
                        : SvgPicture.asset('assets/images/heart.svg');
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              left: 6,
              child: Row(
                children: [
                  if (model.ownerImage != '')
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(model.ownerImage!),
                    )
                  else
                    CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/default_profile.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Text(
                    model.ownerName!,
                    style: Constants.TEXT_STYLE6.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
