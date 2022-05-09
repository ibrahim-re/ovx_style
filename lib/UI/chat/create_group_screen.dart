import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'widgets/group/add_to_group_list_view.dart';
import 'package:ovx_style/UI/chat/widgets/user_search_text_field.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_state.dart';
import 'package:ovx_style/model/group_model.dart';

class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({
    Key? key,
    this.navigator,
    required this.groupName,
  }) : super(key: key);

  final navigator;
  final String groupName;
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  List<String> usersId = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatStates>(
      listener: (ctx, state){
        if(state is CreateGroupLoading)
          EasyLoading.show(status: 'please wait'.tr());

        else if(state is CreateGroupFailed)
          EasyLoading.showError(state.message);

        else if(state is CreateGroupDone) {
          EasyLoading.dismiss();
          NamedNavigatorImpl().push(
              NamedRoutes.GROUP_CHAT_SCREEN, replace: true, arguments: {
            'groupModel': state.groupModel,
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('create group'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                String me = SharedPref.getUser().id!;
                usersId.add(me);
                GroupModel groupModel = GroupModel(groupAdminId: me, usersId: usersId, groupName: widget.groupName, lastUpdated: DateTime.now());
                context.read<ChatBloc>().add(CreateGroup(groupModel));
              },
              child: Text(
                'done'.tr(),
                style: Constants.TEXT_STYLE2.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12, top: 12),
          child: Column(
            children: [
              UserSearchTextField(),
              const SizedBox(height: 16,),
              Expanded(
                child: AddToGroupListView(
                  usersId: usersId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

