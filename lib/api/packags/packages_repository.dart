import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/model/package.dart';

abstract class PackagesRepository {
  Future<Package> getCurrentPackage();
  Future<Package> getFreePackage();
  Future<List<Package>> getAllPackages();
  Future<void> subscribeToPackage(Package package);
  Future<int> getAvailableOffers(OfferType offerType);
  Future<int> getStoryAvailableDays();
  Future<int> getChatAvailableDays();
  Future<int> getStoryCountAvailable();
  Future<void> updateAvailableOffers(OfferType offerType);
  Future<void> updateStoryCountAvailable();
}


class PackagesRepositoryImpl extends PackagesRepository {
  CollectionReference _packages = FirebaseFirestore.instance.collection('packages');
  CollectionReference _subscriptions = FirebaseFirestore.instance.collection('subscriptions');

  @override
  Future<Package> getFreePackage() async {
    try{
      DocumentSnapshot snapshot = await _packages.doc('free package').get();
      final data = snapshot.data() as Map<String, dynamic>;
      Package package = Package.FromMap(data);

      return package;
    }catch (e){
      throw e;
    }
  }

  @override
  Future<Package> getCurrentPackage() async {
    try{
      String uId = SharedPref.getUser().id!;
      DocumentSnapshot snapshot = await _subscriptions.doc(uId).get();
      final packageData = snapshot.data() as Map<String, dynamic>;
      Package package = Package.FromMap(packageData);
      return package;
    }catch (e){
      throw e;
    }
  }

  @override
  Future<List<Package>> getAllPackages() async {
    try{
      List<Package> packages = [];
      //get all packages except free package which has index 0
      QuerySnapshot snapshot = await _packages.orderBy('index').where('index', isNotEqualTo: 0).get();

      for(var doc in snapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        Package package = Package.FromMap(data);
        packages.add(package);
      }

      return packages;
    }catch (e){
      throw e;
    }
  }

  @override
  Future<void> subscribeToPackage(Package package) async {
    try{
      String uId = SharedPref.getUser().id!;
      await _subscriptions.doc(uId).set(package.toMap());
    }catch(e){
      throw e;
    }
  }

  @override
  Future<int> getAvailableOffers(OfferType offerType) async {
    try{
      int availableOffers = 0;
      String uId = SharedPref.getUser().id!;
      final snapshot = await _subscriptions.doc(uId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      switch(offerType){
        case OfferType.Product:
          availableOffers = data['products'];
          break;
        case OfferType.Video:
          availableOffers = data['videos'];
          break;
        case OfferType.Image:
          availableOffers = data['images'];
          break;
        case OfferType.Post:
          availableOffers = data['posts'];
          break;
      }

      return availableOffers;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<int> getChatAvailableDays() async {
    try{
      int availableDays = 0;
      String uId = SharedPref.getUser().id!;
      final snapshot = await _subscriptions.doc(uId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      availableDays = data['chatInDays'];

      return availableDays;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<int> getStoryAvailableDays() async {
    try{
      int availableDays = 0;
      String uId = SharedPref.getUser().id!;
      final snapshot = await _subscriptions.doc(uId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      availableDays = data['storyInDays'];

      return availableDays;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<void> updateAvailableOffers(OfferType offerType) async {
    try{
      String uId = SharedPref.getUser().id!;
      String fieldToUpdate = '';
      switch(offerType){
        case OfferType.Product:
          fieldToUpdate = 'products';
          break;
        case OfferType.Video:
          fieldToUpdate = 'videos';
          break;
        case OfferType.Image:
          fieldToUpdate = 'images';
          break;
        case OfferType.Post:
          fieldToUpdate = 'posts';
          break;
      }
      await _subscriptions.doc(uId).update({
        fieldToUpdate: FieldValue.increment(-1),
      });
    }catch(e){
      throw e;
    }
  }

  @override
  Future<int> getStoryCountAvailable() async {
    try{
      int storyCount = 0;
      String uId = SharedPref.getUser().id!;
      final snapshot = await _subscriptions.doc(uId).get();
      final data = snapshot.data() as Map<String, dynamic>;

      storyCount = data['storyCount'];

      return storyCount;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<void> updateStoryCountAvailable() async {
    try{
      String uId = SharedPref.getUser().id!;

      await _subscriptions.doc(uId).update({
        'storyCount': FieldValue.increment(-1),
      });
    }catch(e){
      throw e;
    }
  }


}