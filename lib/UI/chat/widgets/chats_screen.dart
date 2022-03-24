import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/record_wave_widget.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/model/chatUserModel.dart';
import 'package:provider/src/provider.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'one_chat_item_shape.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    context.read<ChatBloc>().add(GetUserChats(SharedPref.getUser().id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'chats'.tr(),
            style: Constants.TEXT_STYLE1,
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<ChatBloc, ChatStates>(
            builder: (context, state) {
              if (state is GetUserChatsFailed)
                return Center(
                  child: Text(
                    state.err,
                    style: Constants.TEXT_STYLE9,
                  ),
                );
              else if (state is GetUserChatsLoading)
                return Expanded(
                  child: ListView(
                    children: [
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WaitingOfferOwnerRow(
                        withIcon: false,
                      ),
                    ],
                  ),
                );
              else {
                List<ChatUserModel> chats = context.read<ChatBloc>().chatsModel.allChats;
                return chats.isNotEmpty
                    ? Expanded(
                        child: Container(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) => OneChatItem(
                              model: chats[index],
                            ),
                            separatorBuilder: (ctx, index) => Divider(
                              endIndent: 20,
                              indent: 20,
                              thickness: 2,
                              color: Colors.grey.shade200,
                            ),
                            itemCount: chats.length,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'no chats'.tr(),
                          style: Constants.TEXT_STYLE9,
                        ),
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
