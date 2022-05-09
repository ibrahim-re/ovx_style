

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/user_bloc/user_events.dart';
import 'package:ovx_style/bloc/user_bloc/user_states.dart';
import 'package:ovx_style/model/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserSearchInitial());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  String? policy = '';

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if(event is SearchUser){
      yield UserSearchLoading();
      try{
        print('search called');
        List<User> users = await _databaseRepositoryImpl.searchForUsers(event.textToSearch);
        yield UserSearchDone(users);
      }catch (e){
        yield UserSearchFailed('error occurred'.tr());
      }
    }
    else if(event is GetUserPrivacyPolicy){
      yield GetUserPrivacyPolicyLoading();
      try{
        policy = await _databaseRepositoryImpl.getUserPrivacyPolicy(event.uId);
        yield GetUserPrivacyPolicyDone();
      }catch (e){
        yield GetUserPrivacyPolicyFailed('error occurred'.tr());
      }
    }
    else if(event is UpdateUserPrivacyPolicy){
      yield UpdateUserPrivacyPolicyLoading();
      try{
        await _databaseRepositoryImpl.updateUserPrivacyPolicy(event.uId, event.policy);
        policy = event.policy;
        yield UpdateUserPrivacyPolicyDone();
      }catch (e){
        yield UpdateUserPrivacyPolicyFailed('error occurred'.tr());
      }
    }
    else if(event is ChangeCountries){
      yield ChangeCountriesLoading();
      try{
        if(event.changeTo == 'All countries'){
          int totalPoints = await _databaseRepositoryImpl.getPoints(SharedPref.getUser().id!);
          if(totalPoints < 5000)
            yield ChangeCountriesFailed('no enough points'.tr());
          else {
            await _databaseRepositoryImpl.removePoints(5000, SharedPref.getUser().id!);
            await _databaseRepositoryImpl.changeCountries(event.countriesFor, event.changeTo);
            yield ChangeCountriesDone(event.changeTo);
          }
        }else{
          await _databaseRepositoryImpl.changeCountries(event.countriesFor, event.changeTo);
          yield ChangeCountriesDone(event.changeTo);
        }
      }catch (e){
        yield ChangeCountriesFailed('error occurred'.tr());
      }
    }else if(event is ChangeUserLocation){
      yield ChangeUserLocationLoading();
      try{
        await _databaseRepositoryImpl.changeUserLocation(event.latitude, event.longitude, event.country);
        yield ChangeUserLocationDone();
      }catch(e){
        yield ChangeUserLocationFailed('error occurred'.tr());
      }
    }else if(event is GetReceiveGifts){
      yield GetReceiveGiftsLoading();
      try{
        bool receiveGifts = await _databaseRepositoryImpl.getReceiveGifts();
        yield GetReceiveGiftsDone(receiveGifts);
      }catch(e){
        yield GetReceiveGiftsFailed();
      }
    }else if(event is ChangeReceiveGifts){
      yield ChangeReceiveGiftsLoading();
      try{
        await _databaseRepositoryImpl.changeReceiveGifts(event.receiveGifts);
        yield ChangeReceiveGiftsDone(event.receiveGifts);
      }catch(e){
        yield ChangeReceiveGiftsFailed('error occurred'.tr());
      }
    }
  }
}
