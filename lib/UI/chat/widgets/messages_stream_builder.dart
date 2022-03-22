import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/voice_recorder.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/roomModel.dart';

class MessagesStreamBuilder extends StatefulWidget {
  final roomId;
  MessagesStreamBuilder({required this.roomId});
  @override
  State<MessagesStreamBuilder> createState() => _MessagesStreamBuilderState();
}

class _MessagesStreamBuilderState extends State<MessagesStreamBuilder> {
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
  late Stream<Map<String, Message>> messagesStream;

  @override
  void initState() {
    messagesStream = _databaseRepositoryImpl.getChatMessages(widget.roomId);
    super.initState();
  }

  @override
  void dispose() {
    messagesStream = Stream.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, Message>>(
      stream: _databaseRepositoryImpl.getChatMessages(widget.roomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text('error occurred'.tr()),
          );
        }
        if (snapshot.hasData) {
          Map<String, Message> messages = snapshot.data!;
          List<Message> fetchedMessages =
              messages.values.toList().reversed.toList();

          return ListView.separated(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: messages.length,
            separatorBuilder: (ctx, index) => const SizedBox(
              height: 12,
            ),
            itemBuilder: (ctx, index) => MessageAlign(
                msg: fetchedMessages[index].msgValue!,
                sender: fetchedMessages[index].sender!,
                type: fetchedMessages[index].msgType!),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.secondaryColor,
            ),
          );
        } else
          return Container();
      },
    );
  }
}

class MessageAlign extends StatelessWidget {
  final String sender, msg;
  final int type;

  MessageAlign({
    required this.msg,
    required this.sender,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    bool isMe = SharedPref.getUser().id == sender;
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color: isMe
              ? Color.fromRGBO(241, 243, 245, 1)
              : Color.fromRGBO(242, 243, 253, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: MessageShape(
          type: type,
          isMe: isMe,
          msg: msg,
        ),
      ),
    );
  }
}

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
          style: Constants.TEXT_STYLE6.copyWith(
            color:
                MyColors.black, // widget.isMe ? MyColors.black : Colors.white,
          ),
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
                  color: !widget.isMe ? MyColors.secondaryColor : Colors.white,
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
