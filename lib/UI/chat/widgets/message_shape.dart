import 'package:flutter/material.dart';
import 'package:ovx_style/UI/chat/widgets/voice_recorder.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';

class MessageShape extends StatefulWidget {
  final String msg;
  final bool isMe;
  final int type;

  MessageShape({
    required this.msg,
    required this.isMe,
    required this.type,
  });

  @override
  State<MessageShape> createState() => _MessageShapeState();
}

class _MessageShapeState extends State<MessageShape> {
  VoiceRecorder _player = VoiceRecorder();

  @override
  void initState() {
    super.initState();
    _player.init();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          widget.msg,
          style: Constants.TEXT_STYLE6.copyWith(color: widget.isMe ? MyColors.black : Colors.white,),
        ),
      );
    }
    if (widget.type == 1) {
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
                    child: FittedBox(
                        child: Image(image: NetworkImage(widget.msg))),
                  ),
                ));
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/loader-animation.gif'),
            image: NetworkImage(widget.msg),
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    if (widget.type == 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (_player.isStopped()) {
                  await _player.playSavedAudio(widget.msg);
                } else if (_player.isPlaying()) {
                  await _player.pauseSavedAudio();
                } else if (_player.isPaused()) {
                  await _player.resumeSavedAudio();
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
            Expanded(
              child: LinearProgressIndicator(
                color: widget.isMe
                    ? MyColors.secondaryColor.withOpacity(0.2)
                    : Colors.white,
                minHeight: 2,
                value: 1,
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.isMe ? MyColors.secondaryColor : Colors.white,
              ),
              child: Text(
                '0:00',
                style: TextStyle(
                  fontSize: 10,
                  color: widget.isMe ? MyColors.secondaryColor : Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }
}