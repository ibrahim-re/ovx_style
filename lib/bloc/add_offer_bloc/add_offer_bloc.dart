import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/api/packags/packages_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/comment_model.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:ovx_style/model/product_property.dart';

class AddOfferBloc extends Bloc<AddOfferEvent, AddOfferState> {
  AddOfferBloc() : super(AddOfferStateInitial());

  OffersRepositoryImpl _offersRepositoryImpl = OffersRepositoryImpl();
  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();
  PackagesRepositoryImpl _packagesRepositoryImpl = PackagesRepositoryImpl();

  //offer data
  List<String> _offerImages = [];
  String _offerName = '';
  List<String> _categories = [];
  List<String> likes = [];
  List<CommentModel> comments = [];
  String _status = '';
  double _vat = 0;
  double _discount = 0;
  String _discountDate = '';
  String _shortDesc = '';
  List<ProductProperty> _properties = [];
  Map<String, double> _shippingCosts = {};
  bool _isReturnAvailable = false;
  bool _isShippingFree = false;
  List<String> _countries = [];

  String get status => _status;
  List<String> get categories => _categories;
  List<ProductProperty> get properties => _properties;

  @override
  Stream<AddOfferState> mapEventToState(AddOfferEvent event) async* {
    if (event is DeleteOfferButtonPressed) {
      yield DeleteOfferLoading();
      try {
        await _offersRepositoryImpl.deleteOffer(event.offerId, event.offerOwnerType, event.userId);
        yield DeleteOfferSucceed();
      } catch (e) {
        yield DeleteOfferFailed('error occurred'.tr());
      }
    } else if (event is AddProductOfferButtonPressed) {
      yield AddOfferLoading();
      if (_offerImages.isEmpty ||
          _offerName == '' ||
          _status == '' ||
          _categories.isEmpty ||
          _properties.isEmpty) {
        yield AddOfferFailed('Please to fill all required * fields');
      } else {
        try {
          //generate offer id
          String offerId = Helper().generateRandomName();
          //get owner id
          String offerOwnerId = SharedPref.getUser().id ?? '';

          //get owner type
          String offerOwnerType = SharedPref.getUser().userType ?? '';

          //upload offer images to storage if existed
          List<String> urls = [];
          if (_offerImages.isNotEmpty) {
            EasyLoading.dismiss();
            EasyLoading.show(status: 'uploading images'.tr());
            urls = await _databaseRepositoryImpl.uploadFilesToStorage(
                _offerImages, offerOwnerId, 'offers',
                offerId: offerId);
          }

          //convert prices to store in database as USD
          OfferHelper.convertPricesToUSD(_properties);
          _shippingCosts.updateAll(
              (key, value) => value = OfferHelper.convertToUSD(value));

          // //if no country added, add default user country
          // if(_countries.isEmpty)
         // _shippingCountries;
          _shippingCosts.addEntries([
            MapEntry(SharedPref.getUser().countryFlag! + ' ' + SharedPref.getUser().country!, 0),
          ]);
          _countries.add(SharedPref.getUser().country!);

          ProductOffer productOffer = ProductOffer(
            id: offerId,
            offerMedia: urls,
            offerOwnerType: offerOwnerType.toString(),
            offerOwnerId: offerOwnerId,
            offerName: _offerName,
            categories: _categories,
            status: _status,
            properties: _properties,
            shippingCosts: _shippingCosts,
            shortDesc: _shortDesc,
            discount: _discount,
            discountExpireDate: _discountDate,
            isReturnAvailable: _isReturnAvailable,
            isShippingFree: _isShippingFree,
            vat: _vat,
            offerType: event.offerType,
            offerCreationDate: DateTime.now(),
            likes: likes,
            comments: comments,
            countries: _countries,
          );

          //add offer then add offerId to user data
          await _offersRepositoryImpl.addOffer(productOffer.toMap());
          await _databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
          await _packagesRepositoryImpl.updateAvailableOffers(OfferType.Product);
          clearData();
          yield AddOfferSucceed();
        } catch (e) {
          print('error is ${e.toString()}');
          yield AddOfferFailed('error occurred'.tr());
        }
      }
    } else if (event is AddPostOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //generate offer id
        String offerId = Helper().generateRandomName();
        //get owner id
        String offerOwnerId = SharedPref.getUser().id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.getUser().userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        if (event.imagesPath.isNotEmpty) {
          EasyLoading.show(status: 'uploading images'.tr());
          urls = await _databaseRepositoryImpl.uploadFilesToStorage(
              event.imagesPath, offerOwnerId, 'offers',
              offerId: offerId);
        }

        //countries which this offer will appear on
        String postsCountries = SharedPref.getPostsCountries();

        PostOffer postOffer = PostOffer(
          id: offerId,
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          shortDesc: event.shortDesc,
          likes: likes,
          comments: comments,
          countries: [postsCountries],
          offerCreationDate: DateTime.now(),
        );

        await _offersRepositoryImpl.addOffer(postOffer.toMap());
        await _databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        await _packagesRepositoryImpl.updateAvailableOffers(OfferType.Post);
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    } else if (event is AddImageOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //generate offer id
        String offerId = Helper().generateRandomName();
        //get owner id
        String offerOwnerId = SharedPref.getUser().id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.getUser().userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        EasyLoading.show(status: 'uploading images'.tr());
        urls = await _databaseRepositoryImpl.uploadFilesToStorage(
            event.imagesPath, offerOwnerId, 'offers',
            offerId: offerId);

        //countries which this offer will appear on
        String postsCountries = SharedPref.getPostsCountries();

        ImageOffer imageOffer = ImageOffer(
          id: offerId,
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          likes: likes,
          countries: [postsCountries],
          comments: comments,
          offerCreationDate: DateTime.now(),
        );

        await _offersRepositoryImpl.addOffer(imageOffer.toMap());
        await _databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        await _packagesRepositoryImpl.updateAvailableOffers(OfferType.Image);
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    } else if (event is AddVideoOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //generate offer id
        String offerId = Helper().generateRandomName();
        //get owner id
        String offerOwnerId = SharedPref.getUser().id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.getUser().userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        EasyLoading.show(status: 'uploading video'.tr());
        urls = await _databaseRepositoryImpl.uploadFilesToStorage(
            event.videoPath, offerOwnerId, 'offers',
            offerId: offerId);

        //countries which this offer will appear on
        String postsCountries = SharedPref.getPostsCountries();

        VideoOffer videoOffer = VideoOffer(
          id: offerId,
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          likes: likes,
          countries: [postsCountries],
          comments: comments,
          offerCreationDate: DateTime.now(),
        );

        await _offersRepositoryImpl.addOffer(videoOffer.toMap());
        await _databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        await _packagesRepositoryImpl.updateAvailableOffers(OfferType.Video);
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    }
  }

  Map<String, double> get shippingCosts => _shippingCosts;

  addToShippingCosts(MapEntry<String, double> newCost){
    _shippingCosts.addEntries([newCost]);
    _countries.add(Helper().deleteCountryFlag(newCost.key));
  }

  removeFromShippingCosts(String countryToRemove){
    _shippingCosts.removeWhere((key, value) => key == countryToRemove);
    _countries.removeWhere((country) => country == Helper().deleteCountryFlag(countryToRemove));
  }

  clearShippingCosts(){
    _shippingCosts.clear();
    _countries.clear();
  }

  updateOfferImages(List<String> images) {
    _offerImages = images;
  }

  updateIsReturned(bool value) {
    _isReturnAvailable = value;
  }

  updateIsFreeShipping(bool value) {
    _isShippingFree = value;
  }

  updateOfferName(String offerName) {
    _offerName = offerName;
  }

  updateProperties(List<ProductSize> sizes, Color color) async {
    _properties.add(ProductProperty(color: color, sizes: sizes));
  }

  updateStatus(String status) {
    _status = status;
  }

  updateVAT(double vat) {
    _vat = vat;
  }

  updateDiscount(double discount) {
    _discount = discount;
  }

  updateDiscountDate(String discountDate) {
    _discountDate = discountDate;
  }

  updateShortDesc(String shortDesc) {
    _shortDesc = shortDesc;
  }

  updateCategories(String categoryName) {
    _categories.contains(categoryName)
        ? _categories.remove(categoryName)
        : _categories.add(categoryName);
  }

  @override
  Future<void> close() {
    clearData();
    return super.close();
  }

  void clearData() {
    _offerImages = [];
    _offerName = '';
    _categories = [];
    _countries = [];
    _status = '';
    _vat = 0;
    _discount = 0;
    _shortDesc = '';
    _discountDate = '';
    _properties = [];
    _shippingCosts = {};
    _isReturnAvailable = false;
    _isShippingFree = false;
  }
}
