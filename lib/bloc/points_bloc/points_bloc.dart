import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/points_bloc/points_events.dart';
import 'package:ovx_style/bloc/points_bloc/points_states.dart';
import 'package:ovx_style/model/user.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  PointsBloc() : super(PointsInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  int points = 0;

  @override
  Stream<PointsState> mapEventToState(PointsEvent event) async* {
    if (event is SendPoint) {
      yield SendPointsLoading();
      try {
        //check if user exist
        User receiver = await _databaseRepositoryImpl.getUserByUserCode(event.receiverUserCode);

        if (receiver.id != null) {
          print(receiver.id! + 'hhh');

          //check if user has enough points to send
          bool isPointsEnough = points > event.pointsAmount;
          if(!isPointsEnough){
            yield SendPointsFailed('no enough points'.tr());
          }else{
            await _databaseRepositoryImpl.sendPoints(event.senderId, receiver.id!, event.pointsAmount);
            HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendPointsNotification');
            await callable.call(<String, dynamic>{
              'userId': receiver.id,
              'userName': receiver.userName,
              'pointsAmount': event.pointsAmount,
            });
            yield SendPointsSucceed();
          }

        } else {
          yield SendPointsFailed('no user found'.tr());
        }
      } catch (e) {
        print('errir $e');
        if (e == 'Bad state: No element')
          yield SendPointsFailed('no user found'.tr());
        else
          yield SendPointsFailed('error occurred'.tr());
      }
    }
    else if(event is GetPoints){
      yield GetPointsLoading();
      try{
        points = await _databaseRepositoryImpl.getPoints(SharedPref.getUser().id!);
        print('pointd on $points');
        yield GetPointsSucceed();
      }catch (e){
        yield GetPointsFailed();
      }
    }
  }
}
