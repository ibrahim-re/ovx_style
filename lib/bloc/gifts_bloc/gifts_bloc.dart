import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/payment_helper.dart';
import 'package:ovx_style/model/gift.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'gifts_events.dart';
import 'gifts_states.dart';

class GiftsBloc extends Bloc<GiftsEvent, GiftsState> {
  GiftsBloc() : super(GiftsInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  List<Gift> myGifts = [];

  @override
  Stream<GiftsState> mapEventToState(GiftsEvent event) async* {
    if (event is FetchGifts){
      yield FetchGiftsLoading();
      try{
        myGifts = await _databaseRepositoryImpl.fetchGifts(SharedPref.getUser().id!);
        yield FetchGiftsSucceed(myGifts);
      }catch (e){
        yield FetchGiftsFailed('error occurred'.tr());
      }
    }else if(event is SendGift) {
      yield SendGiftLoading();
      try{
        //first get user who will receive the gift
          PaymentHelper.generateAndSendBills(
            event.basketItems,
            event.user.id!,
            event.user.userName!,
            event.user.email!,
            event.user.phoneNumber!,
            event.user.country!,
            event.user.city!,
            event.user.latitude!,
            event.user.longitude!,
          );

          //generate gift id
          String giftId = Helper().generateRandomNumericId();
          List<String> productNames = [];
          event.basketItems.forEach((element) {
            productNames.add(element.productName!);
          });

          print(productNames);
          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendGifts');
          final results = await callable.call(<String, dynamic>{
            'id': giftId,
            'from': SharedPref.getUser().id,
            'to': event.user.id,
            'productNames': productNames,
          });


      }catch (e){
        yield SendGiftFailed('error occurred'.tr());
      }
    }
  }
}
