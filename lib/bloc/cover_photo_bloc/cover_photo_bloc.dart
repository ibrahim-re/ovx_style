import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_events.dart';
import 'package:ovx_style/bloc/cover_photo_bloc/cover_photo_states.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_events.dart';
import 'package:ovx_style/bloc/edit_user_bloc/edit_user_states.dart';

class CoverPhotoBloc extends Bloc<CoverPhotoEvent, CoverPhotoState> {
  CoverPhotoBloc() : super(ChangeCoverPhotoInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  @override
  Stream<CoverPhotoState> mapEventToState(CoverPhotoEvent event) async* {
    if (event is ChangeCoverPhotoButtonPressed) {
      yield ChangeCoverPhotoLoading();
      try {
        List<String> urls = await _databaseRepositoryImpl.uploadFilesToStorage(
          [event.coverImagePath],
          SharedPref.getUser().id!,
          'cover image',
        );

        await _databaseRepositoryImpl.updateCoverImage(urls.first, SharedPref.getUser().id!);
        yield ChangeCoverPhotoSuccess();
      } catch (e) {
        print(e);
        yield ChangeCoverPhotoFailed('error occurred'.tr());
      }
    }
  }
}
