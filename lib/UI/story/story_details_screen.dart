import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ovx_style/UI/offer_details/widget/custom_popup_menu.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/events.dart';
import 'package:ovx_style/model/story_model.dart';
import 'package:provider/src/provider.dart';

class StoryDetails extends StatefulWidget {
  const StoryDetails({Key? key, required this.model, required this.navigator})
      : super(key: key);

  final navigator;
  final oneStoryModel model;

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top,
    ]);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: w,
        height: h,
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: widget.model.storyUrls!.length,
          itemBuilder: (ctx, index) {
            return Stack(
              children: [
                Container(
                  width: w,
                  height: h,
                  child: GestureDetector(
                    onTapDown: (p) {
                      //tap position
                      double dx = p.globalPosition.dx;

                      // if(index == widget.model.storyUrls!.length || index == 0)
                      //   NamedNavigatorImpl().pop();

                      if (dx > w / 2) {
                        if (index == widget.model.storyUrls!.length - 1)
                          NamedNavigatorImpl().pop();
                        else
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                      } else {
                        if (index == 0)
                          NamedNavigatorImpl().pop();
                        else
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                      }
                    },
                    child: Image(
                      image: NetworkImage(widget.model.storyUrls![index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: h * 0.05,
                  left: 0,
                  right: 0,
                  child: TopProgress(
                    story: widget.model,
                    currentIndex: index,
                    pageController: _pageController,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    /*return GestureDetector(
      onTap: () {},
      child: Scaffold(
        body: Container(
          width: w,
          height: h,
          child: Stack(
            children: [
              Container(
                width: w,
                height: h,
                child: Image(
                  image: NetworkImage(widget.model.storyUrls!.first),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: h * 0.05,
                left: 0,
                right: 0,
                child: TopProgress(story: widget.model,),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
                child: Column(
                  children: [
                    Spacer(),
                    OwnerRow(model: widget.model),
                    Description(desc: widget.model.storyDesc!),
                    Reply(),
                  ],
                ),
              ),
              // Positioned(
              //   top: h * 0.75,
              //   left: w * 0.05,
              //   right: w * 0.05,
              //   child: OwnerRow(model: widget.model),
              // ),
              // Positioned(
              //   top: h * 0.82,
              //   left: w * 0.05,
              //   right: w * 0.15,
              //   child: Description(desc: widget.model.storyDesc!),
              // ),
              // Positioned(
              //   bottom: h * 0.05,
              //   left: 0,
              //   right: 0,
              //   child: reply(),
              // ),
            ],
          ),
        ),
      ),
    );*/
  }
}

class TopProgress extends StatelessWidget {
  final oneStoryModel story;
  final PageController pageController;
  final int currentIndex;

  TopProgress(
      {required this.story,
      required this.pageController,
      required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FittedBox(
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: story.storyUrls!.map((url) {
                if (currentIndex == story.storyUrls!.indexOf(url))
                  return Container(
                    width: MediaQuery.of(context).size.width /
                        story.storyUrls!.length,
                    margin: const EdgeInsets.only(right: 6),
                    child: TweenAnimationBuilder(
                      duration: Duration(seconds: 5),
                      onEnd: () {
                        if (currentIndex == story.storyUrls!.length - 1)
                          NamedNavigatorImpl().pop();
                        else
                          pageController.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.bounceIn);
                      },
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.ease,
                      builder: (ctx, value, wid) => LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        value: double.parse(value.toString()),
                        minHeight: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                else
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: MediaQuery.of(context).size.width /
                        story.storyUrls!.length,
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  );
              }).toList(),
            ),
            SizedBox(width: 10),
            CustomPopUpMenu(
              color: Colors.white,
              ownerId: story.ownerId,
              deleteFunction: () {
                context
                    .read<StoriesBloc>()
                    .add(DeleteStory(story.storyId!, story.storyUrls!));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OwnerRow extends StatelessWidget {
  final oneStoryModel model;

  OwnerRow({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
          SizedBox(width: 20),
          Text(
            model.ownerName!,
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          IconButton(
              onPressed: () {},
              icon: model.liked.contains(SharedPref.getUser().id)
                  ? SvgPicture.asset(
                      'assets/images/heart.svg',
                      color: MyColors.red,
                    )
                  : SvgPicture.asset('assets/images/heart.svg')),
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  final String desc;

  Description({required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Text(
        desc,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class Reply extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotatedBox(
              quarterTurns: -45,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white60,
                size: 20,
              ),
            ),
            Text(
              'Relpy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ));
  }
}
