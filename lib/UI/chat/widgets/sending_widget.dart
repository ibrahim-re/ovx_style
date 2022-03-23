import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/voice_recorder.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import '../../../helper/pick_image_helper.dart';

class SendingWidget extends StatefulWidget {
  final roomId;
  final ChatType chatType;

  SendingWidget({required this.roomId, required this.chatType});
  @override
  State<SendingWidget> createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  final TextEditingController _controller = TextEditingController();
  late VoiceRecorder _recorder;
  bool isTyping = false;
  bool isRecoding = false;

  @override
  void initState() {
    _recorder = VoiceRecorder();
    _recorder.init();
    super.initState();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatStates>(
      listener: (context, state) {
        if (state is SendMessageFailed) {
          EasyLoading.showToast(state.message);
        }

        if (state is SendVoiceFailed) {
          EasyLoading.showToast(state.message);
        }
      },
      child: isRecoding
          ? Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final String voice = await _recorder.stopRecord();
                    print('voice is $voice');
                    setState(() => isRecoding = false);

                    if (voice.isNotEmpty && voice != 'no voice') {
                      context.read<ChatBloc>().add(SendVoice(widget.roomId, voice));
                    }
                  },
                  icon: SvgPicture.asset('assets/images/recordVoiceImage.svg'),
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    final String voice = await _recorder.stopRecord();
                    print('voice is $voice');
                    setState(() => isRecoding = false);
                  },
                  icon: SvgPicture.asset('assets/images/trash.svg'),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: Constants.TEXT_STYLE6,
                    controller: _controller,
                    cursorColor: MyColors.secondaryColor,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: 'type here'.tr(),
                      hintStyle: Constants.TEXT_STYLE6.copyWith(
                        color: MyColors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (userInput) {
                      if (userInput.isEmpty)
                        setState(() {
                          isTyping = false;
                        });
                      else
                        setState(() {
                          isTyping = true;
                        });
                    },
                  ),
                ),
                isTyping
                    ? IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            context.read<ChatBloc>().add(
                                SendMessage(widget.roomId, _controller.text, widget.chatType));
                            _controller.clear();
                            setState(() {
                              isTyping = false;
                            });
                          }
                        },
                        icon: SvgPicture.asset(
                          'assets/images/sending.svg',
                          matchTextDirection: true,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyVoiceIcon(
                            (bool isRecord) async {
                              setState(() => isRecoding = isRecord);
                              await _recorder.startRecord();
                            },
                          ),
                          MyImageIcon(widget.roomId),
                        ],
                      ),
              ],
            ),
    );
  }
}

class MyImageIcon extends StatelessWidget {
  final String roomId;

  MyImageIcon(this.roomId);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final imageSource = await PickImageHelper().showPicker(context);
        if (imageSource == null) return;
        List<File> pickedFiles = [];
        if (imageSource == ImageSource.camera) {
          File file = await PickImageHelper().pickImageFromSource(imageSource);
          pickedFiles.add(file);
        } else {
          pickedFiles = await PickImageHelper().pickMultiImages();
        }

        BlocProvider.of<ChatBloc>(context).add(
          UploadImageToRoom(
            roomId,
            pickedFiles[0],
          ),
        );
      },
      icon: SvgPicture.asset('assets/images/sendingimage.svg'),
    );
  }
}

class MyVoiceIcon extends StatelessWidget {
  final Function Record_func;
  MyVoiceIcon(this.Record_func);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Record_func(true);
      },
      icon: SvgPicture.asset('assets/images/sendingvoice.svg'),
    );
  }
}
