import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_events.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_states.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc() : super(EditUserInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Stream<EditUserState> mapEventToState(EditUserEvent event) async* {
   if(event is EditUserButtonPressed ){
     yield EditUserLoading();
     try{
       if(event.profileImage.isNotEmpty){
         //if user already has profile image, delete them first
         if(event.userData['profileImage'] != '')
           await _databaseRepositoryImpl.deleteFilesFromStorage([event.userData['profileImage']]);

         EasyLoading.show(status: 'update profile image'.tr());
         List<String> urls = await _databaseRepositoryImpl.uploadFilesToStorage([event.profileImage], SharedPref.getUser().id!, 'profileImage');
         //update profile image url
         event.userData['profileImage'] = urls.first;
       }

       if(event.regImages.isNotEmpty){
         //if user already has reg images, delete them first
         if(event.userData['regImages'] != [])
           await _databaseRepositoryImpl.deleteFilesFromStorage(event.userData['regImages']);

         EasyLoading.show(status: 'update reg images'.tr());
         List<String> urls = await _databaseRepositoryImpl.uploadFilesToStorage(event.regImages, SharedPref.getUser().id!, 'regImages');
         //update profile image url
         event.userData['regImages'] = urls;
       }

       await _databaseRepositoryImpl.updateUserData(event.userData, SharedPref.getUser().id!);

       yield EditUserSuccess();
     }catch (e) {
       print(e);
       yield EditUserFailed('error occurred'.tr());
     }
   }
  }
}