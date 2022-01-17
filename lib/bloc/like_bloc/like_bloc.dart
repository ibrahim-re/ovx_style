import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/bloc/like_bloc/like_events.dart';
import 'package:ovx_style/bloc/like_bloc/like_states.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState>{
  LikeBloc() : super(LikeInitialState());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();

  @override
  Stream<LikeState> mapEventToState(LikeEvent event) async* {
    if(event is LikeButtonPressed){
      try {
        await offersRepositoryImpl.updateLikes(event.offerId, event.offerOwnerId, event.userId);
        yield LikeDone();
      } catch (e) {
        yield LikeFailed('error occurred'.tr());
      }
    }
  }

}