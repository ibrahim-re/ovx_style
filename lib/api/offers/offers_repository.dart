import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/category.dart';
import 'package:ovx_style/model/comment_model.dart';
import 'package:ovx_style/model/offer.dart';

abstract class OffersRepository {
  Future<void> addOffer(Map<String, dynamic> productOffer);
  Future<List<Category>> getCategories();
  Future<List<Offer>> getOffers(UserType offerOwnerType);
  Future<void> deleteOffer(String offerId, String offerOwnerType, String userId);
  Future<void> updateLikes(String offerId, String offerOwnerId, String userId);
  Future<void> addCommentToOffer(String offerId, String offerOwnerId, Map<String, dynamic> commentData);
  Future<List<CommentModel>> fetchOfferComments(String offerId, String offerOwnerId);
  Future<void> deleteComment(String offerId, Map<String, dynamic> data, String offerOwnerId);
  Future<Map<String, double>> getCurrencies();

}

class OffersRepositoryImpl extends OffersRepository {
  CollectionReference _offers = FirebaseFirestore.instance.collection('offers');
  CollectionReference _companyOffers = FirebaseFirestore.instance.collection('company offers');
  CollectionReference _categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference _currencies = FirebaseFirestore.instance.collection('currencies');

  @override
  Future<void> addOffer(Map<String, dynamic> productOffer) async {
    try {
      if (productOffer['offerOwnerType'] == UserType.Person.toString()) {
       await _offers.doc(productOffer['id']).set(productOffer);
      } else {
        await _companyOffers.doc(productOffer['id']).set(productOffer);
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
        fetchedCategories.add(Category(name: categoryName, subCategories: subCategories));
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
  Future<void> updateLikes(String offerId, String offerOwnerId, String userId) async {
    try {
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

      //first get owner id type (person or company)
      String offerOwnerType = await databaseRepositoryImpl.getUserType(offerOwnerId);

      //check if user is person or company
      if (offerOwnerType == UserType.Person.toString()) {

        //check and see if this is like or dislike
        if (SharedPref.getUser().offersLiked!.contains(offerId)) {
          await _offers.doc(offerId).update({
            'likes': FieldValue.arrayRemove([userId])
          });
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, false);
        } else {
          await _offers.doc(offerId).update({
            'likes': FieldValue.arrayUnion([userId])
          });
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, true);
        }
      } else {

        //check and see if this is like or dislike
        if (SharedPref.getUser().offersLiked!.contains(offerId)) {
          await _companyOffers.doc(offerId).update({
            'likes': FieldValue.arrayRemove([userId])
          });
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, false);
        } else {
          await _companyOffers.doc(offerId).update({
            'likes': FieldValue.arrayUnion([userId])
          });
          await databaseRepositoryImpl.updateOfferLiked(offerId, userId, true);
        }
      }
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  @override
  Future<void> addCommentToOffer(String offerId, String offerOwnerId, Map<String, dynamic> commentData) async {
    try {
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

      //first get owner id type (person or company)
      String offerOwnerType = await databaseRepositoryImpl.getUserType(offerOwnerId);

      //check if user is person or company
      if (offerOwnerType == UserType.Person.toString()) {
        await _offers.doc(offerId).update({
          'comments': FieldValue.arrayUnion([commentData]),
        });
      } else {
        await _companyOffers.doc(offerId).update({
          'comments': FieldValue.arrayUnion([commentData]),
        });
      }

      await databaseRepositoryImpl.updateComments(offerId, commentData['userId']);
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  @override
  Future<List<CommentModel>> fetchOfferComments(String offerId, String offerOwnerId) async {
    try {
      List<CommentModel> comments = [];
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

      //first get owner id type (person or company)
      String offerOwnerType = await databaseRepositoryImpl.getUserType(offerOwnerId);

      //check if user is person or company
      if (offerOwnerType == UserType.Person.toString()) {

        final DocumentSnapshot data = await _offers.doc(offerId).get();
        final d = data.data() as Map<String ,dynamic>;
        comments = (d['comments'] as List<dynamic>).map((e) => CommentModel.fromMap(e)).toList();

      } else {

        final DocumentSnapshot data = await _companyOffers.doc(offerId).get();
        final d = data.data() as Map<String ,dynamic>;
        comments = (d['comments'] as List<dynamic>).map((e) => CommentModel.fromMap(e)).toList();

      }

      return comments;
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  @override
  Future<void> deleteComment(String offerId, Map<String, dynamic> data, String offerOwnerId) async {

    try {
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

      //first get owner id type (person or company)
      String offerOwnerType = await databaseRepositoryImpl.getUserType(offerOwnerId);

      //check if user is person or company
      if (offerOwnerType == UserType.Person.toString()) {

        await _offers.doc(offerId).update({
          'comments': FieldValue.arrayRemove([data])
        });

      } else {

        await _companyOffers.doc(offerId).update({
          'comments': FieldValue.arrayRemove([data])
        });

      }


      await databaseRepositoryImpl.updateComments(offerId, data['userId']);
    } catch (e) {
      print('error is $e');
      throw e;
    }
  }

  @override
  Future<void> deleteOffer(String offerId, String offerOwnerType, String userId) async {
    try {
      DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

      if(offerOwnerType == UserType.Company.toString())
        await _companyOffers.doc(offerId).delete();
      else
        await _offers.doc(offerId).delete();

      databaseRepositoryImpl.updateOfferAdded(userId, offerId);
    } catch (e) {
      print(e.toString());
      throw e;
    }

  }

  @override
  Future<Map<String, double>> getCurrencies() async {
    Map<String, double> fetchedCurrencies = {};
    try {
      final documentSnapshot = await _currencies.doc('currencies prices').get();
      fetchedCurrencies = (documentSnapshot.data() as Map<String, dynamic>).cast();

      return fetchedCurrencies;
    } on FirebaseException catch (e) {
      print('errorrrr is ${e.code}');
      throw e.code;
    } catch (e) {
      print('error code is $e');
      throw e;
    }
  }
}
