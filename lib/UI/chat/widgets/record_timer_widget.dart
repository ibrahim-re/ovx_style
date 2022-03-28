import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';

class TimerController extends ValueNotifier<TimerAction>{
  TimerController({TimerAction timerState = TimerAction.Stop}) : super(timerState);

  void startTimer() => value = TimerAction.Start;

  void stopTimer() => value = TimerAction.Stop;

  void pauseTimer() => value = TimerAction.Pause;

  void resumeTimer() => value = TimerAction.Resume;

}


class RecordTimerWidget extends StatefulWidget {
  final Color color;
  final TimerController timerController;

  RecordTimerWidget({required this.color, required this.timerController});

  @override
  _RecordTimerWidgetState createState() => _RecordTimerWidgetState();
}

class _RecordTimerWidgetState extends State<RecordTimerWidget> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    widget.timerController.addListener(() {
      if(widget.timerController.value == TimerAction.Start) {
        print('timer started');
        startTimer();
      }
      else if(widget.timerController.value == TimerAction.Stop) {
        print('timer stopped');
        stopTimer();
      }
      else if(widget.timerController.value == TimerAction.Pause) {
        print('timer paused');
        stopTimer(reset: false);
      }
      else if(widget.timerController.value == TimerAction.Resume) {
        print('timer resumed');
        startTimer();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if(timer != null)
      timer!.cancel();
    super.dispose();
  }

  void resetTimer(){
    setState(() {
      duration = Duration();
    });
    timer!.cancel();
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime(){
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  void stopTimer({bool reset = true}){
    if(reset)
      resetTimer();
    else
      setState(() {
        timer?.cancel();
      });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');


  @override
  Widget build(BuildContext context) {
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: Constants.TEXT_STYLE6.copyWith(color: widget.color),
    );
  }
}
