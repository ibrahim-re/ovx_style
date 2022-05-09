import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/one_chat_item_shape.dart';
import 'package:ovx_style/UI/widgets/no_available_days_widget.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import '../../../bloc/chat_bloc/chat_event.dart';
import '../../../bloc/chat_bloc/chat_state.dart';
import '../../../model/chatUserModel.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    BlocProvider.of<ChatBloc>(context).add(GetContacts());
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
            'public chat'.tr(),
            style: Constants.TEXT_STYLE1,
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<ChatBloc, ChatStates>(
            builder: (context, state) {
              if (state is GetContactsFailed) {
                if (state.err == 'no available days'.tr())
                  return NoAvailableDaysWidget();
                else
                  return Center(
                    child: Text(
                      state.err,
                      style: Constants.TEXT_STYLE9,
                      textAlign: TextAlign.center,
                    ),
                  );
              }
              else if (state is ChatInitial || state is GetContactsLoading)
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
                List<ChatUserModel> chats = context.read<ChatBloc>().contactsModel;
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
                          'no contacts'.tr(),
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
