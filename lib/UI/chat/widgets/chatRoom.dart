import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';

import '../../../bloc/chat_bloc/chat_event.dart';
import '../../../bloc/chat_bloc/chat_state.dart';
import '../../../helper/pick_image_helper.dart';
import '../../../model/roomModel.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({
    Key? key,
    this.navigator,
    required this.anoherUserName,
    required this.anoherUserImage,
    required this.roomId,
  }) : super(key: key);

  final navigator;
  final String anoherUserName;
  final String anoherUserImage;
  final String roomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController con = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool sendTextStatus = false;
  RoomModel? room;

  late StreamController<String> st;
  String uploadedImageUrl = '';

  @override
  void initState() {
    st = StreamController();
    BlocProvider.of<ChatBloc>(context).add(FetchRoomMessages(widget.roomId));
    st.stream.listen((event) {
      if (event.isNotEmpty && sendTextStatus == false) {
        setState(() => sendTextStatus = true);
      }

      if (event.isEmpty || con.text.isEmpty) {
        setState(() => sendTextStatus = false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_new)),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: widget.anoherUserImage == 'no image'
                  ? Image.asset('assets/images/default_profile.png').image
                  : NetworkImage(widget.anoherUserImage),
            ),
            SizedBox(width: 10),
            Text(widget.anoherUserName.toString())
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            BlocConsumer<ChatBloc, ChatStates>(
              listener: (context, state) {
                print(state.toString());
                if (state is GETChatMessageLoadingState) {}
                if (state is GETChatMessageDoneState) {
                  room = state.model;
                }

                if (state is GETChatMessageFailedState) {
                  EasyLoading.showError(
                    'Opps, Something went wrong ',
                    duration: Duration(
                      seconds: 2,
                    ),
                  );
                }

                if (state is UploadeImageToRoomDoneState) {
                  uploadedImageUrl = state.imageUrl;
                }
              },
              builder: (context, state) {
                return room == null
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MyColors.secondaryColor,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            reverse: true,
                            itemBuilder: (ctx, index) {
                              final message = room!.messages![index];
                              return messageAlign(
                                message.msgvalue!,
                                message.sender!,
                                message.msgtype!,
                              );
                            },
                            separatorBuilder: (ctx, index) =>
                                SizedBox(height: 14),
                            itemCount: room!.messages!.length,
                          ),
                        ),
                      );
              },
            ),
            Container(
              height: 60,
              color: MyColors.primaryColor,
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 14,
                          color: MyColors.secondaryColor,
                        ),
                        controller: con,
                        cursorColor: MyColors.secondaryColor,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Type Here',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: MyColors.lightGrey,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            EasyLoading.showError('Empty Field');
                            return '';
                          }
                          return null;
                        },
                        onChanged: (String val) {
                          st.add(val);
                        },
                      ),
                    ),
                  ),
                  sendTextStatus
                      ? sendingIcon()
                      : Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              voiceIcon(),
                              imageIcon(),
                            ],
                          ),
                        ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sendingIcon() {
    return IconButton(
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
        } else {
          final sendingData = {
            'type': 0,
            'value': con.text.trim(),
            'sender': SharedPref.getUser().id!,
            'createdAt': DateTime.now().toIso8601String(),
          };
          room!.messages!.insert(0, Messages.fromJson(sendingData));
          con.clear();
          sendTextStatus = false;
          setState(() {});
          BlocProvider.of<ChatBloc>(context).add(
            sendMessage(
              widget.roomId,
              sendingData,
            ),
          );
        }
      },
      icon: SvgPicture.asset('assets/images/sending.svg'),
    );
  }

  Widget voiceIcon() {
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

  Widget imageIcon() {
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
        final sendingData = {
          'type': 1,
          'value': '',
          'sender': SharedPref.getUser().id!,
          'createdAt': DateTime.now().toIso8601String(),
        };
        room!.messages!.insert(0, Messages.fromJson(sendingData));
        uploadedImageUrl = '';
        setState(() {});

        BlocProvider.of<ChatBloc>(context).add(
          UploadeImageToRoom(
            widget.roomId,
            pickedFiles[0],
          ),
        );
      },
      icon: SvgPicture.asset('assets/images/sendingimage.svg'),
    );
  }

  Widget messageAlign(String msg, String sender, int type) {
    bool isMe = SharedPref.getUser().id == sender;
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color:
              isMe ? Color.fromRGBO(241, 243, 245, 1) : MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: MessageShape(type, msg, isMe),
      ),
    );
  }

  Widget MessageShape(int type, String msg, bool isMe) {
    if (type == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          msg,
          style: TextStyle(
            color: isMe ? Color.fromRGBO(68, 68, 68, 1) : Colors.white,
          ),
        ),
      );
    }
    if (type == 1) {
      msg = msg == '' ? uploadedImageUrl : msg;
      return msg != ''
          ? ClipRRect(
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
                                  child: Image(image: NetworkImage(msg))),
                            ),
                          ));
                },
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loader-animation.gif'),
                  image: NetworkImage(msg != '' ? msg : uploadedImageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: MyColors.secondaryColor,
              ),
            );
    }

    return Container();
  }
}
