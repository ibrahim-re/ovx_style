import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_states.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/offer.dart';
import 'offer_events.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc() : super(OfferStateInitial());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();

  List<Offer> fetchedOffers = [];
  List<String> showOnly = [];

  void updateShowOnly(String offerType) {
    if (!showOnly.contains(offerType))
      showOnly.add(offerType);
    else
      showOnly.remove(offerType);
  }

  List<Offer> getMyOffers() {
    return fetchedOffers
        .where((offer) => offer.offerOwnerId == SharedPref.getUser().id)
        .toList();
  }

  List<Offer> getMyLikedOffers() {
    return fetchedOffers
        .where((offer) => offer.likes!.contains(SharedPref.getUser().id))
        .toList();
  }

  List<Offer> getUserOffers(String id) {
    return fetchedOffers.where((offer) => offer.offerOwnerId == id).toList();
  }

  @override
  Stream<OfferState> mapEventToState(OfferEvent event) async* {
    if (event is FetchOffers) {
      yield FetchOffersLoading();
      try {
        fetchedOffers = await offersRepositoryImpl.getOffers(event.offerOwnerType);
        showOnly.clear();
        yield FetchOffersSucceed(fetchedOffers);
      } catch (e) {
        print('error is ${e.toString()}');
        yield FetchOffersFailed('network error'.tr());
      }
    } else if (event is FilterOffers) {
      yield FetchOffersLoading();

      if (showOnly.isEmpty)
        yield FetchOffersSucceed(fetchedOffers);

      //check if show only contains product to filter by price and categories
      else if (showOnly.contains(OfferType.Product.toString())) {
        //first filter by types
        List<Offer> filteredOffers = fetchedOffers
            .where((offer) => showOnly.contains(offer.offerType))
            .toList();
        print(filteredOffers.length);

        //then filter product offer type by categories
        if (event.categories.isNotEmpty)
          filteredOffers =
              OfferHelper.filterCategories(filteredOffers, event.categories);

        //then filter product offer type by price
        filteredOffers = OfferHelper.filterPrices(
            filteredOffers, event.minPrice, event.maxPrice);

        print(filteredOffers.length);
        yield FetchOffersSucceed(filteredOffers);
      } else {
        List<Offer> filteredOffers = fetchedOffers
            .where((offer) => showOnly.contains(offer.offerType))
            .toList();
        yield FetchOffersSucceed(filteredOffers);
      }
    }
  }
}
