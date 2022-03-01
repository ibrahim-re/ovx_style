import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/bloc/stories_bloc/states.dart';
import 'package:ovx_style/model/story_model.dart';

class Story extends StatelessWidget {
  Story({Key? key, required this.model}) : super(key: key);

  final oneStoryModel model;

  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: Image(
                image: AssetImage('assets/images/loader-animation.gif'),
              ).image,
              image: Image(
                image: NetworkImage(model.storyUrl!),
              ).image,
              fit: BoxFit.fill,
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
                      model.liked.contains(SharedPref.getUser().id),
                    ),
                  );
                },
                icon: BlocConsumer<StoriesBloc, StoriesBlocStates>(
                  listener: (context, state) {
                    if (state is MakeStroyFavoriteDoneState) {
                      if (state.storyId == model.storyId) {
                        if (model.liked.contains(SharedPref.getUser().id)) {
                          model.liked.removeWhere(
                            (element) => element == SharedPref.getUser().id,
                          );
                        } else {
                          model.liked.add(SharedPref.getUser().id);
                        }
                      }
                    }
                  },
                  builder: (context, state) {
                    return model.liked.contains(SharedPref.getUser().id)
                        ? Icon(
                            Icons.favorite,
                            color: MyColors.primaryColor,
                            size: 30,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: MyColors.primaryColor,
                            size: 30,
                          );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 6,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(model.ownerImage!),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    model.ownerName!,
                    style: TextStyle(
                      color: MyColors.primaryColor,
                      fontSize: 14,
                    ),
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
