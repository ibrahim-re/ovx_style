import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/chat/widgets/user_search_text_field.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_bloc.dart';
import 'package:ovx_style/bloc/chat_bloc/chat_event.dart';
import 'package:ovx_style/bloc/user_bloc/user_bloc.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';
import 'package:shimmer_image/shimmer_image.dart';

class CreateChatScreen extends StatefulWidget {
  CreateChatScreen({
    Key? key,
    this.navigator,
  }) : super(key: key);

  final navigator;
  @override
  _CreateChatScreenState createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create chat'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12, top: 12),
        child: Column(
          children: [
            UserSearchTextField(),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocConsumer<UserBloc, UserState>(
                listener: (ctx, state) {
                  if (state is UserSearchFailed)
                    EasyLoading.showError(state.message);
                },
                builder: (ctx, state) {
                  if (state is UserSearchLoading)
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.secondaryColor,
                      ),
                    );
                  else if (state is UserSearchDone) {
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (ctx, index) => InkWell(
                        onTap: () {
                          BlocProvider.of<ChatBloc>(context).add(
                            CreateRoom(
                              SharedPref.getUser().id!,
                              state.users[index].id!,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: state.users[index].profileImage!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: ProgressiveImage(
                                        imageError:
                                            'assets/images/no_internet.png',
                                        image: state.users[index].profileImage!,
                                        height: 55,
                                        width: 55,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                          'assets/images/default_profile.jpg'),
                                    ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              state.users[index].userName!,
                              style: Constants.TEXT_STYLE4,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
