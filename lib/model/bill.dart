
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class Bill{
  String? id;
  DateTime? date;
  dynamic amount;
  String? productName;
  dynamic productPrice;
  Color? productColor;
  String? productSize;
  dynamic vat;
  dynamic shippingCost;
  String? shipTo;
  String? buyerName;
  String? buyerEmail;
  String? buyerPhoneNumber;
  String? buyerCountry;
  String? buyerCity;
  dynamic buyerLongitude;
  dynamic buyerLatitude;
  bool? isRequested;

  Bill({
    required this.id,
    required this.date,
    required this.productSize,
    required this.amount,
    required this.productPrice,
    required this.productColor,
    required this.buyerName,
    required this.buyerPhoneNumber,
    required this.productName,
    required this.buyerEmail,
    required this.isRequested,
    this.buyerLatitude,
    this.buyerLongitude,
    this.vat,
    this.shipTo,
    this.buyerCity,
    this.buyerCountry,
    this.shippingCost,
  });

  Bill.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    this.buyerPhoneNumber = map['buyerPhoneNumber'] ?? '';
    this.date = (map['date'] as Timestamp).toDate();
    this.productSize = map['productSize'] ?? '';
    this.amount = OfferHelper.convertFromUSD(map['amount'] ?? 0);
    this.productPrice = OfferHelper.convertFromUSD(map['productPrice'] ?? 0);
    this.productColor = Color(map['productColor']);
    this.buyerName = map['buyerName'] ?? '';
    this.productName = map['productName'] ?? '';
    this.buyerEmail = map['buyerEmail'] ?? '';
    this.buyerLatitude = map['buyerLatitude'] ?? 0;
    this.buyerLongitude = map['buyerLongitude'] ?? 0;
    this.vat = map['vat'];
    this.isRequested = map['isRequested'];
    this.shipTo = map['shipTo'] ?? '';
    this.buyerCity = map['buyerCity'] ?? '';
    this.buyerCountry = map['buyerCountry'] ?? '';
    this.shippingCost = OfferHelper.convertFromUSD(map['shippingCost']);
  }

  Map<String, dynamic> toMap() => {
    'buyerPhoneNumber': buyerPhoneNumber,
    'date': date,
    'productSize': productSize,
    'amount': amount,
    'productPrice': productPrice,
    'productColor': productColor!.value,
    'buyerName': buyerName,
    'productName': productName,
    'buyerEmail': buyerEmail,
    'buyerLatitude': buyerLatitude,
    'isRequested': isRequested,
    'buyerLongitude': buyerLongitude,
    'vat': vat,
    'shipTo': shipTo,
    'buyerCity': buyerCity,
    'buyerCountry': buyerCountry,
    'shippingCost': shippingCost,
  };

}