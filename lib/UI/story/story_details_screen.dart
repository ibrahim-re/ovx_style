import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/model/story_model.dart';

class StoryDetails extends StatefulWidget {
  const StoryDetails({Key? key, required this.model, required this.navigator})
      : super(key: key);

  final navigator;
  final oneStoryModel model;

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
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
                  image: NetworkImage(widget.model.storyUrl!),
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: h * 0.05,
                left: 0,
                right: 0,
                child: topProgress(),
              ),
              Positioned(
                bottom: h * 0.15,
                left: w * 0.05,
                right: w * 0.05,
                child: ownerRow(widget.model),
              ),
              Positioned(
                bottom: h * 0.10,
                left: w * 0.05,
                right: w * 0.15,
                child: descreption(widget.model.storyDesc!),
              ),
              Positioned(
                bottom: h * 0.05,
                left: 0,
                right: 0,
                child: reply(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topProgress() {
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
            Container(
              width: MediaQuery.of(context).size.width,
              child: TweenAnimationBuilder(
                duration: Duration(seconds: 5),
                onEnd: () => Navigator.of(context).pop(),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                builder: (ctx, value, wid) => LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  value: double.parse(value.toString()),
                  minHeight: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            PopupMenuButton(
              padding: EdgeInsets.zero,
              iconSize: 40,
              enabled: true,
              offset: Offset(-1, 50),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    height: 3,
                    enabled: true,
                    value: 'Report',
                    onTap: () {
                      print('Send report');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bug_report),
                        SizedBox(width: 4),
                        Text('Report'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget ownerRow(oneStoryModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(model.ownerImage!),
          ),
          SizedBox(width: 20),
          Text(
            model.ownerName!,
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              model.liked.contains(SharedPref.getUser().id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget descreption(String desc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Text(
        desc,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget reply() {
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
