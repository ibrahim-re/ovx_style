import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';

class SendingWidget extends StatefulWidget {
  final roomId;

  SendingWidget({required this.roomId});
  @override
  State<SendingWidget> createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatStates>(
      listener: (context, state) {
        if (state is SendMessageFailed) {
          EasyLoading.showToast(state.message);
        }
      },
      child: Row(
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
                      context
                          .read<ChatBloc>()
                          .add(SendMessage(widget.roomId, _controller.text));
                      _controller.clear();
                      setState(() {
                        isTyping = false;
                      });
                    }
                  },
                  icon: SvgPicture.asset('assets/images/sending.svg', matchTextDirection: true,),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyVoiceIcon(),
                    MyImageIcon(),
                  ],
                ),
        ],
      ),
    );
  }
}

class MyImageIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // final imageSource = await PickImageHelper().showPicker(context);
        // if (imageSource == null) return;
        // List<File> pickedFiles = [];
        // if (imageSource == ImageSource.camera) {
        //   File file = await PickImageHelper().pickImageFromSource(imageSource);
        //   pickedFiles.add(file);
        // } else {
        //   pickedFiles = await PickImageHelper().pickMultiImages();
        // }
        // final sendingData = {
        //   'type': 1,
        //   'value': '',
        //   'sender': SharedPref.getUser().id!,
        //   'createdAt': DateTime.now().toIso8601String(),
        // };
        // room!.messages!.insert(0, Messages.fromJson(sendingData));
        // uploadedImageUrl = '';
        // setState(() {});
        //
        // BlocProvider.of<ChatBloc>(context).add(
        //   UploadeImageToRoom(
        //     widget.roomId,
        //     pickedFiles[0],
        //   ),
        // );
      },
      icon: SvgPicture.asset('assets/images/sendingimage.svg'),
    );
  }
}

class MyVoiceIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // print('aa');

        // final record = Record();

        // // Check and request permission
        // bool result = await record.hasPermission();

        // // Start recording
        // await record.start(
        //   path: 'aFullPath/myFile.m4a', // required
        //   encoder: AudioEncoder.AAC, // by default
        //   bitRate: 128000, // by default
        //   // sampleRate: 44100, // by default
        // );

        // // Get the state of the recorder
        // // bool isRecording = await record.isRecording();

        // // // Stop recording
        // // await record.stop();
      },
      icon: SvgPicture.asset('assets/images/sendingvoice.svg'),
    );
  }
}
