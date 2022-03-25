import 'package:flutter/material.dart';
import 'package:ovx_style/UI/chat/widgets/record_timer_widget.dart';
import 'package:ovx_style/UI/chat/widgets/record_wave_widget.dart';
import '../../../helper/voice_recorder_helper.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class MessageShape extends StatelessWidget {
  final String msg;
  final bool isMe;
  final int type;

  MessageShape({
    required this.msg,
    required this.isMe,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          msg,
          style: Constants.TEXT_STYLE6.copyWith(
            color: isMe ? MyColors.black : Colors.white,
          ),
        ),
      );
    }
    if (type == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      actionsPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.zero,
                      titlePadding: EdgeInsets.zero,
                      buttonPadding: EdgeInsets.zero,
                      content: Container(
                        padding: EdgeInsets.zero,
                        child:
                            FittedBox(child: Image(image: NetworkImage(msg))),
                      ),
                    ));
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/loader-animation.gif'),
            image: NetworkImage(msg),
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    if (type == 2) {
      return VoiceMessageShape(
        msg: msg,
        isMe: isMe,
        type: type,
      );
    }

    return Container();
  }
}

class VoiceMessageShape extends StatefulWidget {
  final String msg;
  final bool isMe;
  final int type;

  VoiceMessageShape({
    required this.msg,
    required this.isMe,
    required this.type,
  });

  @override
  _VoiceMessageShapeState createState() => _VoiceMessageShapeState();
}

class _VoiceMessageShapeState extends State<VoiceMessageShape> {
  VoiceRecorderHelper _player = VoiceRecorderHelper();
  TimerController timerController = TimerController();

  @override
  void initState() {
    _player.initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _player.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (_player.isStopped()) {
                await _player.playSavedAudio(widget.msg, () {
                  setState(() {
                    _player.flag = 0;
                  });
                  timerController.stopTimer();
                });
                timerController.startTimer();
              } else if (_player.isPlaying()) {
                await _player.pauseSavedAudio();
                timerController.pauseTimer();
              } else if (_player.isPaused()) {
                await _player.resumeSavedAudio();
                timerController.resumeTimer();
              }

              setState(() {});
            },
            child: Icon(
              _player.flag == 0
                  ? Icons.play_circle_outline_rounded
                  : _player.flag == 2
                      ? Icons.play_arrow
                      : _player.flag == 1 || _player.flag == 3
                          ? Icons.pause
                          : Icons.star,
              color: widget.isMe ? MyColors.secondaryColor : Colors.white,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: _player.flag == 0 || _player.flag == 2
                ? Divider(
                    color: MyColors.secondaryColor,
                    thickness: 2,
                  )
                : RecordWavesWidget(),
          ),
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 20,
            backgroundColor:
                widget.isMe ? MyColors.secondaryColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: RecordTimerWidget(
                  color: widget.isMe ? Colors.white : MyColors.secondaryColor,
                  timerController: timerController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
