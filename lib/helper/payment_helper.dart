//This class is for initializing and implementing TAP payment gateway
import 'dart:io';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';

class PaymentHelper {
  //holds payment response data
  static Map<dynamic, dynamic>? tapSDKResult = {};

  // configure SDK
  static void setupPayment(double amount, String userEmail, String userName, String currency) {
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

  static void _setupSDKSession(double amount, String userEmail, String userName, String currency) {
    final isProduction = false;

    try {
      GoSellSdkFlutter.sessionConfigurations(
          trxMode: TransactionMode.PURCHASE,
          transactionCurrency: "$currency", // TODO: Currency
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
          merchantID:
              "11107285",
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
}
