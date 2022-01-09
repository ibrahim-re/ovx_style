import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/category.dart';
import 'package:ovx_style/model/offer.dart';

abstract class OffersRepository {
  Future<String> addOffer(Map<String, dynamic> productOffer);
  Future<List<Category>> getCategories();
  Future<List<Offer>> getOffers(UserType offerOwnerType);
  Future<void> updateLikes(String offerId, String userId);
}

class OffersRepositoryImpl extends OffersRepository {
  CollectionReference _offers = FirebaseFirestore.instance.collection('offers');
  CollectionReference _companyOffers = FirebaseFirestore.instance.collection('company offers');
  CollectionReference _categories = FirebaseFirestore.instance.collection('categories');

  @override
  Future<String> addOffer(Map<String, dynamic> productOffer) async {
    try {
      if (productOffer['offerOwnerType'] == UserType.Person.toString()) {
        final documentRef = await _offers.add(productOffer);
        return documentRef.id;
      } else {
        final documentRef = await _companyOffers.add(productOffer);
        return documentRef.id;
      }
    } on FirebaseException catch (e) {
      print('error code is ${e.code}');
      throw e.code;
    } catch (e) {
      print('hhhhhhh');
      throw e;
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    List<Category> fetchedCategories = [];
    try {
      final documentSnapshot = await _categories.get();
      for (QueryDocumentSnapshot q in documentSnapshot.docs) {
        String categoryName = q.id;
        final data = q.data() as Map<String, dynamic>;
        List<dynamic> subCategories = data['subCategories'];
        fetchedCategories
            .add(Category(name: categoryName, subCategories: subCategories));
      }
      return fetchedCategories;
    } on FirebaseException catch (e) {
      print('error codeeeee is ${e.code}');
      throw e.code;
    } catch (e) {
      print('error code is $e');
      throw e;
    }
  }

  @override
  Future<List<Offer>> getOffers(UserType offerOwnerType) async {
    try {
      List<Offer> fetchedOffers = [];
      QuerySnapshot query;
      if (offerOwnerType == UserType.Person)
        query = await _offers.orderBy('offerCreationDate', descending: true).get();
      else
        query = await _companyOffers.orderBy('offerCreationDate', descending: true).get();

      for (var e in query.docs) {
        final data = e.data() as Map<String, dynamic>;
        final offerId = e.id;

        if (data['offerType'] == OfferType.Product.toString()) {
          ProductOffer offer = ProductOffer.fromMap(data, offerId);
          fetchedOffers.add(offer);
        } else if (data['offerType'] == OfferType.Post.toString()) {
          PostOffer offer = PostOffer.fromMap(data, offerId);
          fetchedOffers.add(offer);
        } else if (data['offerType'] == OfferType.Image.toString()) {
          ImageOffer offer = ImageOffer.fromMap(data, offerId);
          fetchedOffers.add(offer);
        } else if (data['offerType'] == OfferType.Video.toString()) {
          VideoOffer offer = VideoOffer.fromMap(data, offerId);
          fetchedOffers.add(offer);
        }
      }

      return fetchedOffers;
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  @override
  Future<void> updateLikes(String offerId, String userId) async {
    try {
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
      //check if user is person or company
      if (SharedPref.currentUser.userType == UserType.Person.toString()){

        //check and see if this is like or dislike
        if(SharedPref.currentUser.offersLiked!.contains(offerId)) {
          await _offers.doc(offerId).update({'likes': FieldValue.arrayRemove([userId])});
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, false);
        } else {
          await _offers.doc(offerId).update({'likes': FieldValue.arrayUnion([userId])});
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, true);
        }
      } else {

        //check and see if this is like or dislike
        if(SharedPref.currentUser.offersLiked!.contains(offerId)) {
          await _companyOffers.doc(offerId).update({'likes': FieldValue.arrayRemove([userId])});
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, false);
        }
        else{
          await _companyOffers.doc(offerId).update({'likes': FieldValue.arrayUnion([userId])});
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, true);
        }

      }
    }catch (e) {
      print('error $e');
      throw e;
    }
  }
}
