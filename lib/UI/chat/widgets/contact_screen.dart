import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/one_chat_item_shape.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';

import '../../../model/chatUserModel.dart';

class Contacts_Chat extends StatefulWidget {
  const Contacts_Chat({Key? key}) : super(key: key);
  @override
  State<Contacts_Chat> createState() => _Contacts_ChatState();
}

class _Contacts_ChatState extends State<Contacts_Chat> {
  bool isLoading = true;
  List<ChatUserModel> chats = [];
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(FetchAllChats());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Public chat',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          BlocConsumer<ChatBloc, ChatStates>(
            listener: (context, state) {
              if (state is GETAllChatInitial ||
                  state is GETAllChatLoadingState) {
                isLoading = true;
                EasyLoading.show(status: 'please wait'.tr());
              }

              if (state is GETAllChatDoneState) {
                EasyLoading.dismiss();
                isLoading = false;
                chats = state.model.allChats;
              }

              if (state is GETAllChatFailedState) {
                EasyLoading.dismiss();

                isLoading = false;
                EasyLoading.showError(state.err);
              }
            },
            builder: (context, state) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, index) => oneChatItem(
                      model: chats[index],
                    ),
                    separatorBuilder: (ctx, index) => Divider(
                      endIndent: 20,
                      indent: 20,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemCount: chats.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
