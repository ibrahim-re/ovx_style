import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/offer.dart';
import 'offer_events.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(OfferStateInitial());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();
  DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
  List<Offer> fetchedOffers = [];

  //in case many requests sent at same time
  bool alreadyFetchingMoreOffer = false;

  @override
  Stream<OfferState> mapEventToState(OfferEvent event) async* {
    //fetch offers for first time
    if (event is FetchOffers) {
      yield FetchOffersLoading();
      try {
        fetchedOffers = await offersRepositoryImpl.getOffers(event.offerOwnerType);
        yield FetchOffersSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield FetchOffersFailed('network error'.tr());
      }
    }
    //fetch more offers
    else if (event is FetchMoreOffers && !alreadyFetchingMoreOffer) {
      alreadyFetchingMoreOffer = true;
      yield FetchMoreOffersLoading();
      try {
        List<Offer> offers = await offersRepositoryImpl.getOffers(event.offerOwnerType, lastFetchedOfferId: event.lastFetchedOfferId);
        fetchedOffers.addAll(offers);
        alreadyFetchingMoreOffer = false;
        yield FetchMoreOffersSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        alreadyFetchingMoreOffer = false;
        yield FetchMoreOffersFailed('network error'.tr());
      }
    }
    else if(event is GetUserOffers){
      yield GetUserOffersLoading();
      try{
        List<Offer> offers = await offersRepositoryImpl.getUserOffers(event.uId, event.offerOwnerType);
        print('user offers ${offers.length}');
        yield GetUserOffersDone(offers);
      }catch(e){
        yield GetUserOffersFailed('error occurred'.tr());
      }
    }
    else if(event is GetMyLikedOffers){
      yield GetMyLikedOffersLoading();
      try{
        List<Offer> offers = await offersRepositoryImpl.getMyLikedOffers(event.uId);
        yield GetMyLikedOffersDone(offers);
      }catch (e){
        yield GetMyLikedOffersFailed('error occurred'.tr());
      }
    }
    else if(event is GetFilteredOffers){
      yield GetFilteredOffersLoading();
      try{
        List<Offer> offers = await offersRepositoryImpl.getFilteredOffers(event.minPrice, event.maxPrice, event.status, event.categories, event.offerTypes, event.userType);
        OfferHelper.categories.clear();
        OfferHelper.status = '';
        yield GetFilteredOffersDone(offers);
      }catch (e){
        yield GetFilteredOffersFailed('error occurred'.tr());
      }
    }
  }
}
