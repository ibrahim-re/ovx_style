import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_events.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_states.dart';
import 'package:ovx_style/helper/basket_helper.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/helper/offer_helper.dart';
import 'package:ovx_style/model/bill.dart';
import 'package:cloud_functions/cloud_functions.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  BillsBloc() : super(BillsInitialized());

  DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

  List<Bill> myBills = [];

  double calculateTotalBillsAmount(){
    double total = 0;

    myBills.forEach((bill) {
      if(!bill.isRequested!)
        total += bill.amount;
    });

    return double.parse(total.toStringAsFixed(2));
  }

  @override
  Stream<BillsState> mapEventToState(BillsEvent event) async* {
    if (event is AddBills) {
      yield AddBillsLoading();

      print('staaaaaaaaaaaart');
      try{

        /*we will generate one bill for each basket item
        and send each bill to each seller.*/

        /*and make sure if multi items belongs to one seller
        calculate shipping cost only one by help of
        this list*/
        List<String> doneItems = [];

        List<Bill> generatedBillsToSend = [];

        for (var item in event.basketItems) {
          //generate bill id
          String billId = Helper().generateRandomNumericId();

          /*if this item done before don't add ship cost,
          it's already added in previous bill*/
          double shipCost = 0;
          if (!doneItems.contains(item.productId)) shipCost = item.shippingCost ?? 0;

          double billTotalAmount = item.price! + shipCost + BasketHelper.calculateVAT(item.price!, item.vat!);

          Bill newBill = Bill(
            id: billId,
            isRequested: false,
            date: DateTime.now(),
            amount: billTotalAmount,
            productColor: item.color,
            productSize: item.size,
            productPrice: item.price,
            buyerName: SharedPref.getUser().userName,
            buyerPhoneNumber: SharedPref.getUser().phoneNumber,
            productName: item.productName,
            buyerEmail: SharedPref.getUser().email,
            shipTo: item.shipTo ?? '',
            shippingCost: shipCost,
            vat: item.vat ?? 0,
            buyerCity: SharedPref.getUser().city ?? '',
            buyerCountry: SharedPref.getUser().country ?? '',
            buyerLatitude: SharedPref.getUser().latitude ?? 0,
            buyerLongitude: SharedPref.getUser().longitude ?? 0,
          );

          // add item to done items
          doneItems.add(item.productId!);

          generatedBillsToSend.add(newBill);
        } //end for

        //now send the bills to the sellers
        for (int i = 0; i < generatedBillsToSend.length; i++) {
          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendBills');
          final results = await callable.call(<String, dynamic>{
            'sellerId': event.basketItems[i].productOwnerId!,
            'isRequested': generatedBillsToSend[i].isRequested,
            'billId': generatedBillsToSend[i].id,
            'amount': OfferHelper.convertToUSD(generatedBillsToSend[i].amount!),
            'productName': generatedBillsToSend[i].productName,
            'productPrice': OfferHelper.convertToUSD(generatedBillsToSend[i].productPrice!),
            'productColor': generatedBillsToSend[i].productColor!.value,
            'productSize': generatedBillsToSend[i].productSize,
            'vat': generatedBillsToSend[i].vat,
            'shippingCost': OfferHelper.convertToUSD(generatedBillsToSend[i].shippingCost!),
            'shipTo': generatedBillsToSend[i].shipTo,
            'buyerName': generatedBillsToSend[i].buyerName,
            'buyerEmail': generatedBillsToSend[i].buyerEmail,
            'buyerPhoneNumber': generatedBillsToSend[i].buyerPhoneNumber,
            'buyerCountry': generatedBillsToSend[i].buyerCountry,
            'buyerCity': generatedBillsToSend[i].buyerCity,
            'buyerLongitude': generatedBillsToSend[i].buyerLongitude,
            'buyerLatitude': generatedBillsToSend[i].buyerLatitude,
          });

          print('bill $i sent ${results.data}');

          //add points to buyer
          _databaseRepositoryImpl.addPoints(250, SharedPref.getUser().id!);
          //add points to seller is done in backend
          // _databaseRepositoryImpl.addPoints(250, event.basketItems[i].productOwnerId!);


          // await _databaseRepositoryImpl.addBill(
          //   event.basketItems[i].productOwnerId!,
          //   generatedBillsToSend[i],
          // );
        }

        yield AddBillsSucceed();

      }catch (e) {
        print('error bills $e');
        yield AddBillsFailed();
      }
    }
    else if (event is FetchBills){
      yield FetchBillsLoading();
      try{
        myBills = await _databaseRepositoryImpl.fetchBills(SharedPref.getUser().id!);
        yield FetchBillsSucceed(myBills);
      }catch (e){
        yield FetchBillsFailed('error occurred'.tr());
      }
    }else if(event is RequestBill){
      yield BillRequestLoading();
      _databaseRepositoryImpl.requestBill(event.userId, event.billId);
      try {
        yield BillRequested();
      } catch (e) {
        yield BillRequestFailed('');
      }
    }
  }
}
