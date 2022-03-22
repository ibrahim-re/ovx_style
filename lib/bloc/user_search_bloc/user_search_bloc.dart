

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/user_search_bloc/user_search_events.dart';
import 'package:ovx_style/bloc/user_search_bloc/user_search_states.dart';
import 'package:ovx_style/model/user.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc() : super(UserSearchInitial());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();


  @override
  Stream<UserSearchState> mapEventToState(UserSearchEvent event) async* {
    if(event is SearchUser){
      yield UserSearchLoading();
      try{
        List<User> users = await _databaseRepositoryImpl.searchForUsers(event.textToSearch);
        print('users is ${users.length}');
        yield UserSearchDone(users);
      }catch (e){
        yield UserSearchFailed('error occurred'.tr());
      }
    }
  }
}
