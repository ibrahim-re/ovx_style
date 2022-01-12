import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_events.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_states.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:ovx_style/model/product_property.dart';

class AddOfferBloc extends Bloc<AddOfferEvent, AddOfferState> {
  AddOfferBloc() : super(AddOfferStateInitial());

  OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();
  DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
  //AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();

  //offer data
  List<String> _offerImages = [];
  String _offerName = '';
  List<String> _categories = [];
  List<String> likes = [];
  String _status = '';
  double _vat = 0;
  double _discount = 0;
  String _discountDate = '';
  String _shortDesc = '';
  List<ProductProperty> _properties = [];
  Map<String, double> _shippingCosts = {};
  bool _isReturnAvailable = false;
  bool _isShippingFree = false;

  String get status => _status;
  List<String> get categories => _categories;
  List<ProductProperty> get properties => _properties;

  @override
  Stream<AddOfferState> mapEventToState(AddOfferEvent event) async* {
    if (event is AddProductOfferButtonPressed) {
      yield AddOfferLoading();
      if ( _offerImages.isEmpty || _offerName == '' || _status == '' || _categories.isEmpty || _properties.isEmpty){
        yield AddOfferFailed('Please to fill all required * fields');}
      else {
        try {
          //get owner id
          String offerOwnerId = SharedPref.currentUser.id ?? '';

          //get owner type
          String offerOwnerType = SharedPref.currentUser.userType ?? '';

          //upload offer images to storage if existed
          List<String> urls = [];
          if (_offerImages.isNotEmpty) {
            EasyLoading.show(status: 'uploading images'.tr());
            urls = await databaseRepositoryImpl.uploadFilesToStorage(
                _offerImages, offerOwnerId, 'offers');
          }

          ProductOffer productOffer = ProductOffer(
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
          );

          //add offer then add offerId to user data
          String offerId = await offersRepositoryImpl.addOffer(productOffer.toMap());
          await databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
          clearData();
          NamedNavigatorImpl().pop();
          yield AddOfferSucceed();
        } catch (e) {
          print('error is ${e.toString()}');
          yield AddOfferFailed('error occurred'.tr());
        }
      }
    } else if (event is AddPostOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //get owner id
        String offerOwnerId = SharedPref.currentUser.id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.currentUser.userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        if (event.imagesPath.isNotEmpty) {
          EasyLoading.show(status: 'uploading images'.tr());
          urls = await databaseRepositoryImpl.uploadFilesToStorage(
              event.imagesPath, offerOwnerId, 'offers');
        }
        PostOffer postOffer = PostOffer(
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          shortDesc: event.shortDesc,
          likes: likes,
          offerCreationDate: DateTime.now(),
        );

        String offerId = await offersRepositoryImpl.addOffer(postOffer.toMap());
        await databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        NamedNavigatorImpl().pop();
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    }
    else if (event is AddImageOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //get owner id
        String offerOwnerId = SharedPref.currentUser.id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.currentUser.userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        EasyLoading.show(status: 'uploading images'.tr());
        urls = await databaseRepositoryImpl.uploadFilesToStorage(event.imagesPath, offerOwnerId, 'offers');

        ImageOffer imageOffer = ImageOffer(
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          likes: likes,
          offerCreationDate: DateTime.now(),
        );

        String offerId = await offersRepositoryImpl.addOffer(imageOffer.toMap());
        await databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        NamedNavigatorImpl().pop();
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    }
    else if (event is AddVideoOfferButtonPressed) {
      yield AddOfferLoading();
      try {
        //get owner id
        String offerOwnerId = SharedPref.currentUser.id ?? '';

        //get owner type
        String offerOwnerType = SharedPref.currentUser.userType ?? '';

        //upload offer images to storage if existed
        List<String> urls = [];
        EasyLoading.show(status: 'uploading video'.tr());
        urls = await databaseRepositoryImpl.uploadFilesToStorage(event.videoPath, offerOwnerId, 'offers');

        VideoOffer videoOffer = VideoOffer(
          offerMedia: urls,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
          offerType: event.offerType,
          likes: likes,
          offerCreationDate: DateTime.now(),
        );

        String offerId = await offersRepositoryImpl.addOffer(videoOffer.toMap());
        await databaseRepositoryImpl.updateOfferAdded(offerOwnerId, offerId);
        NamedNavigatorImpl().pop();
        yield AddOfferSucceed();
      } catch (e) {
        print('error is ${e.toString()}');
        yield AddOfferFailed('error occurred'.tr());
      }
    }
  }

  updateShippingCost(Map<String, double> shippingCosts) {
    _shippingCosts.addAll(shippingCosts);
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

  updateProperties(List<ProductSize> sizes, Color color) {
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
