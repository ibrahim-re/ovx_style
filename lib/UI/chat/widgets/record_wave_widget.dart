import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';

class RecordWavesWidget extends StatelessWidget {

  final List<int> durations = [900,700,600,800,500];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: new List<Widget>.generate(12, (index) => RecordWave(duration: durations[index%5],)),
    );
  }
}


class RecordWave extends StatefulWidget {
  //final Color color;
  final int duration;

  RecordWave({required this.duration});

  @override
  _RecordWaveState createState() => _RecordWaveState();
}

class _RecordWaveState extends State<RecordWave> with SingleTickerProviderStateMixin{

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedAnimation = CurvedAnimation(parent: animationController!, curve: Curves.bounceIn);
    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)..addListener(() {
      setState(() {

      });
    });

    animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    animation!.removeListener(() { });
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: animation!.value / 2,
      decoration: BoxDecoration(
        color: MyColors.secondaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
