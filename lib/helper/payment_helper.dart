//This class is for initializing and implementing TAP payment gateway
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/model/basket.dart';
import 'package:ovx_style/model/bill.dart';

import 'basket_helper.dart';
import 'helper.dart';
import 'offer_helper.dart';

class PaymentHelper {
  //holds payment response data
  static Map<dynamic, dynamic>? tapSDKResult = {};

  // configure SDK
  static void setupPayment(
      double amount, String userEmail, String userName, String currency) {
    // configure app
    _configureApp();
    // sdk session configurations
    _setupSDKSession(amount, userEmail, userName, currency);
  }

  // configure app key and bundle-id (You must get those keys from tap)
  static void _configureApp() {
    final isAndroid = Platform.isAndroid;
    GoSellSdkFlutter.configureApp(
        bundleId: isAndroid ? "com.ovx.ovx_style" : "com.ovx.ovxStyle",
        productionSecreteKey: isAndroid
            ? "sk_live_UFiuMP60sXLR29l41d8zSK7a"
            : "sk_live_la2q0AVob8iwPQBumHGkzeLI",
        sandBoxsecretKey: isAndroid
            ? "sk_test_wZLbPCsAVWcYjFfquEG2RapU"
            : "sk_test_zCWbpIsJwqgdTNrG6L5YHoQR",
        lang: "en");
  }

  static void _setupSDKSession(
      double amount, String userEmail, String userName, String currency) {
    final isProduction = false;

    try {
      GoSellSdkFlutter.sessionConfigurations(
          trxMode: TransactionMode.PURCHASE,
          transactionCurrency: "$currency",
          // TODO: Currency
          amount: '$amount',
          customer: Customer(
            customerId: '',
            email: "$userEmail",
            isdNumber: "",
            number: "",
            firstName: "$userName",
            middleName: "",
            lastName: "",
          ),
          paymentItems: [],
          // List of taxes
          taxes: [],
          // List of shipping
          shippings: [],
          // Post URL
          postURL: "https://tap.company",
          // Payment description
          paymentDescription: "paymentDescription",
          //Payment Metadata
          paymentMetaData: {},
          //Payment Reference
          paymentReference: Reference(
              acquirer: "acquirer",
              gateway: "gateway",
              payment: "payment",
              track: "track",
              transaction: "trans_910101",
              order: "order_262625"),
          //payment Descriptor
          paymentStatementDescriptor: "paymentStatementDescriptor",
          // Save Card Switch
          isUserAllowedToSaveCard: true,
          // Enable/Disable 3DSecure
          isRequires3DSecure: true,
          //Receipt SMS/Email
          receipt: Receipt(false, true),
          //Authorize Action [Capture - Void]
          authorizeAction: AuthorizeAction(
              type: AuthorizeActionType.CAPTURE, timeInHours: 10),
          //Destinations
          destinations: null,
          // merchant id
          merchantID: "11107285",
          // Allowed cards
          allowedCadTypes: CardType.CREDIT,
          // applePayMerchantID: "",
          allowsToSaveSameCardMoreThanOnce: false,
          // pass the card holder name to the SDK
          cardHolderName: "Card Holder NAME",
          // disable changing the card holder name by the user
          allowsToEditCardHolderName: true,
          // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
          paymentType: PaymentType.CARD,
          // Transaction mode
          sdkMode: isProduction ? SDKMode.Production : SDKMode.Sandbox);
    } catch (e) {
      print('error is $e');
    }
  }

  static Future<String> startPayment() async {
    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;

    print('>>>> ${tapSDKResult}');

    return tapSDKResult!['acquirer_response_message'] ?? '';
  }

  static Future<void> generateAndSendBills(
      List<BasketItem> basketItems,
      String buyerId,
      String buyerName,
      String buyerEmail,
      String buyerPhoneNumber,
      String buyerCountry,
      String buyerCity,
      double latitude,
      double longitude) async {
    /*we will generate one bill for each basket item
        and send each bill to each seller.*/

    /*and make sure if multi items belongs to one seller
        calculate shipping cost only one by help of
        this list*/
    List<String> doneItems = [];

    List<Bill> generatedBillsToSend = [];

    for (var item in basketItems) {
      //generate bill id
      String billId = Helper().generateRandomNumericId();

      /*if this item done before don't add ship cost,
          it's already added in previous bill*/
      double shipCost = 0;
      if (!doneItems.contains(item.productId))
        shipCost = item.shippingCost ?? 0;

      double billTotalAmount = item.price! + shipCost + BasketHelper.calculateVAT(item.price!, item.vat!);
      
      //remove company's share 10% from the total amount
      billTotalAmount = billTotalAmount - (billTotalAmount * 0.1);
      Bill newBill = Bill(
        id: billId,
        isRequested: false,
        date: DateTime.now(),
        amount: billTotalAmount,
        productColor: item.color,
        productSize: item.size,
        productPrice: item.price,
        buyerName: buyerName,
        buyerPhoneNumber: buyerPhoneNumber,
        productName: item.productName,
        buyerEmail: buyerEmail,
        shipTo: item.shipTo ?? '',
        shippingCost: shipCost,
        vat: item.vat ?? 0,
        buyerCity: buyerCity,
        buyerCountry: buyerCountry,
        buyerLatitude: latitude,
        buyerLongitude: longitude,
      );

      // add item to done items
      doneItems.add(item.productId!);

      generatedBillsToSend.add(newBill);
    } //end for

    DatabaseRepositoryImpl _databaseRepositoryImpl = DatabaseRepositoryImpl();

    //now send the bills to the sellers
    for (int i = 0; i < generatedBillsToSend.length; i++) {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendBills');
      final results = await callable.call(<String, dynamic>{
        'sellerId': basketItems[i].productOwnerId!,
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
      _databaseRepositoryImpl.addPoints(250, buyerId);
      //add points to seller is done in backend
      // _databaseRepositoryImpl.addPoints(250, event.basketItems[i].productOwnerId!);
    }
  }
}
