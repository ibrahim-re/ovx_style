import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'one_group_item.dart';
import 'package:ovx_style/UI/offers/widgets/waiting_offer_owner_row.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/group_model.dart';
import 'package:provider/src/provider.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    context.read<ChatBloc>().add(GetGroups(SharedPref.getUser().id!));
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
            'groups'.tr(),
            style: Constants.TEXT_STYLE1,
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<ChatBloc, ChatStates>(
            builder: (context, state) {
              if (state is GetGroupsFailed)
                return Center(
                  child: Text(
                    state.message,
                    style: Constants.TEXT_STYLE9,
                  ),
                );
              else if (state is GetGroupsLoading)
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
                List<GroupModel> groups = context.read<ChatBloc>().groups;
                return groups.isNotEmpty
                    ? Expanded(
                        child: Container(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (ctx, index) => OneGroupItem(
                              groupModel: groups[index],
                            ),
                            separatorBuilder: (ctx, index) => Divider(
                              endIndent: 20,
                              indent: 20,
                              thickness: 2,
                              color: Colors.grey.shade200,
                            ),
                            itemCount: groups.length,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'no groups'.tr(),
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
