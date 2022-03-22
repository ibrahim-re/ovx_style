import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/bloc/user_search_bloc/user_search_bloc.dart';
import 'package:ovx_style/bloc/user_search_bloc/user_search_states.dart';
import 'package:shimmer_image/shimmer_image.dart';

class AddToGroupListView extends StatefulWidget {
  final List<String> usersId;

  AddToGroupListView({required this.usersId});

  @override
  _AddToGroupListViewState createState() => _AddToGroupListViewState();
}

class _AddToGroupListViewState extends State<AddToGroupListView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSearchBloc, UserSearchState>(builder: (ctx, state) {
      if (state is UserSearchLoading)
        return Center(
          child: CircularProgressIndicator(
            color: MyColors.secondaryColor,
          ),
        );
      else if (state is UserSearchFailed)
        return Center(
          child: Text(
            state.message,
            style: Constants.TEXT_STYLE9,
          ),
        );
      else if (state is UserSearchDone) {
        return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (ctx, index) => InkWell(
              onTap: (){
                String selectedUserId = state.users[index].id!;
                setState(() {
                  if(widget.usersId.contains(selectedUserId))
                    widget.usersId.removeWhere((id) => id == selectedUserId);
                  else
                    widget.usersId.add(selectedUserId);
                });
              },
              child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: state.users[index].profileImage!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ProgressiveImage(
                                  imageError: 'assets/images/no_internet.png',
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
                      Spacer(),
                      widget.usersId.contains(state.users[index].id)
                          ? Icon(
                              Icons.done,
                        color: MyColors.secondaryColor,
                            )
                          : Container(),
                    ],
                  ),
            ));
      } else
        return Container();
    });
  }
}
