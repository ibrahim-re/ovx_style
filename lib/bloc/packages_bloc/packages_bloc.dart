import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/api/packags/packages_repository.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_event.dart';
import 'package:ovx_style/bloc/packages_bloc/packages_state.dart';
import 'package:ovx_style/model/package.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  PackagesBloc() : super(PackagesInitialState());
  List<Package> packages = [];
  Package? currentPackage;
  int chatAvailableDays = 0;

  PackagesRepositoryImpl _packagesRepositoryImpl = PackagesRepositoryImpl();

  @override
  Stream<PackagesState> mapEventToState(PackagesEvent event) async* {
    if(event is GetCurrentPackage){
      yield GetCurrentPackageLoading();
      try{
        currentPackage = await _packagesRepositoryImpl.getCurrentPackage();
        yield GetCurrentPackageDone();
      }catch(e){
        print('error us$e');
        yield GetCurrentPackageFailed('error occurred'.tr());
    }
    }
    else if(event is GetAllPackages){
      yield GetAllPackagesLoading();
      try{
        packages = await _packagesRepositoryImpl.getAllPackages();
        yield GetAllPackagesDone();
      }catch(e){
        print('error us$e');
        yield GetAllPackagesFailed('error occurred'.tr());
      }
    }
    else if(event is SubscribeToPackage){
      yield SubscribeToPackageLoading();
      try{
        await _packagesRepositoryImpl.subscribeToPackage(event.package);
        yield SubscribeToPackageDone();
      }catch(e){
        print('error is $e');
        yield SubscribeToPackageFailed('error occurred'.tr());
      }
    }
    else if(event is GetAvailableOffersCount){
      yield GetAvailableOffersLoading();
      try{
        int availableOffers = await _packagesRepositoryImpl.getAvailableOffers(event.offerType);
        yield GetAvailableOffersDone(availableOffers);
      }catch(e){
        print('error is $e');
        yield GetAvailableOffersFailed('error occurred'.tr());
      }
    }
    else if(event is GetChatAvailableDays){
      yield GetChatAvailableDaysLoading();
      try{
        chatAvailableDays = await _packagesRepositoryImpl.getChatAvailableDays();
        yield GetChatAvailableDaysDone();
      }catch(e){
        print('error is $e');
        yield GetChatAvailableDaysFailed('error occurred'.tr());
      }
    }
    // else if(event is GetStoryAvailableDays){
    //   yield GetStoryAvailableDaysLoading();
    //   try{
    //     int availableDays = await _packagesRepositoryImpl.getStoryAvailableDays();
    //     yield GetStoryAvailableDaysDone(availableDays);
    //   }catch(e){
    //     print('error is $e');
    //     yield GetStoryAvailableDaysFailed('error occurred'.tr());
    //   }
    // }
  }
}
