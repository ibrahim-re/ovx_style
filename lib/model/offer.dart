import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovx_style/model/product_property.dart';
import 'package:flutter/material.dart';

class Offer {
  String? id;
  List<String>? offerMedia;
  String? offerType;
  String? offerOwnerType;
  String? offerOwnerId;
  DateTime? offerCreationDate;
  //a list contains users ids
  List<String>? likes;

  Offer(
      {this.id,
      required this.offerMedia,
      required this.offerType,
      required this.offerOwnerType,
      required this.offerOwnerId,
      required this.offerCreationDate,
      this.likes});

  Offer.fromMap(Map<String, dynamic> offerInfo, String offerId) {
    this.id = offerId;
    this.offerMedia = (offerInfo['offerMedia'] as List<dynamic>).map((e) => e.toString()).toList();
    this.offerType = offerInfo['offerType'];
    this.offerOwnerType = offerInfo['offerOwnerType'];
    this.offerOwnerId = offerInfo['offerOwnerId'];
    this.offerCreationDate = (offerInfo['offerCreationDate'] as Timestamp).toDate();
    this.likes = (offerInfo['likes'] as List<dynamic>).map((e) => e.toString()).toList();
  }
}

class ProductOffer extends Offer {
  String? offerName;
  List<String>? categories;
  String? status;
  double? vat;
  double? discount;
  String? discountExpireDate;
  String? shortDesc;
  List<ProductProperty>? properties;
  Map<String, double>? shippingCosts;
  bool? isReturnAvailable;
  bool? isShippingFree;

  ProductOffer({
    id,
    required offerMedia,
    likes,
    required offerOwnerType,
    required offerOwnerId,
    required offerType,
    required offerCreationDate,
    required this.offerName,
    required this.categories,
    required this.status,
    this.vat = 0,
    this.discount = 0,
    this.discountExpireDate = '',
    this.shortDesc = '',
    required this.properties,
    this.shippingCosts,
    this.isShippingFree = false,
    this.isReturnAvailable = false,
  }) : super(
          id: id,
          offerMedia: offerMedia,
          likes: likes,
          offerCreationDate: offerCreationDate,
          offerType: offerType,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
        );

  Map<String, dynamic> toMap() => {
        'offerMedia': offerMedia,
        'offerOwnerType': offerOwnerType,
        'offerOwnerId': offerOwnerId,
        'offerCreationDate': offerCreationDate,
        'offerType': offerType,
        'categories': categories,
        'status': status,
        'vat': vat,
        'discount': discount,
        'discountExpireDate': discountExpireDate,
        'shortDesc': shortDesc,
        'properties': properties!.map((e) => e.toMap()).toList(),
        'shippingCosts': shippingCosts,
        'isShippingFree': isShippingFree,
        'isReturnAvailable': isReturnAvailable,
        'likes': likes,
      };

  ProductOffer.fromMap(Map<String, dynamic> offerInfo, String offerId) : super.fromMap(offerInfo, offerId) {
    this.id = offerId;
    this.offerName = offerInfo['offerName'];
    this.categories = (offerInfo['categories'] as List<dynamic>).map((e) => e.toString()).toList();
    this.status = offerInfo['status'];
    this.vat = offerInfo['vat'];
    this.discount = offerInfo['discount'];
    this.discountExpireDate = offerInfo['discountExpireDate'];
    this.shortDesc = offerInfo['shortDesc'];
    this.properties = (offerInfo['properties'] as List<dynamic>).map((e) => ProductProperty(color: Color(e['color']), sizes: (e['sizes'] as List<dynamic>).map((e) => ProductSize(size: e['size'], price: e['price'])).toList())).toList();
    this.shippingCosts = (offerInfo['shippingCosts'] as Map<String, dynamic>).map((key, value) {return MapEntry(key, value);});
    this.isReturnAvailable = offerInfo['isReturnAvailable'];
    this.isShippingFree = offerInfo['isShippingFree'];
  }
}

class PostOffer extends Offer {
  String? shortDesc;

  PostOffer({
    id,
    offerMedia,
    likes,
    required offerOwnerType,
    required offerOwnerId,
    required offerCreationDate,
    required offerType,
    required this.shortDesc,
  }) : super(
          id: id,
          offerMedia: offerMedia,
          offerType: offerType,
          likes: likes,
          offerCreationDate: offerCreationDate,
          offerOwnerType: offerOwnerType,
          offerOwnerId: offerOwnerId,
        );

  Map<String, dynamic> toMap() => {
        'offerMedia': offerMedia,
        'offerOwnerType': offerOwnerType,
        'offerOwnerId': offerOwnerId,
        'offerCreationDate': offerCreationDate,
        'offerType': offerType,
        'shortDesc': shortDesc,
        'likes': likes,
      };

  PostOffer.fromMap(Map<String, dynamic> offerInfo, String offerId)
      : super.fromMap(offerInfo, offerId) {
    this.shortDesc = offerInfo['shortDesc'];
  }
}

class ImageOffer extends Offer {
  ImageOffer({
    id,
    likes,
    required offerMedia,
    required offerOwnerType,
    required offerOwnerId,
    required offerCreationDate,
    required offerType,
  }) : super(
          id: id,
          likes: likes,
          offerMedia: offerMedia,
          offerType: offerType,
          offerOwnerType: offerOwnerType,
          offerCreationDate: offerCreationDate,
          offerOwnerId: offerOwnerId,
        );

  Map<String, dynamic> toMap() => {
        'offerMedia': offerMedia,
        'offerOwnerType': offerOwnerType,
        'offerOwnerId': offerOwnerId,
        'offerCreationDate': offerCreationDate,
        'offerType': offerType,
        'likes': likes,
      };

  ImageOffer.fromMap(Map<String, dynamic> offerInfo, String offerId)
      : super.fromMap(offerInfo, offerId);
}

class VideoOffer extends Offer {
  VideoOffer({
    id,
    likes,
    required offerMedia,
    required offerOwnerType,
    required offerOwnerId,
    required offerCreationDate,
    required offerType,
  }) : super(
          id: id,
          likes: likes,
          offerMedia: offerMedia,
          offerType: offerType,
          offerOwnerType: offerOwnerType,
          offerCreationDate: offerCreationDate,
          offerOwnerId: offerOwnerId,
        );

  Map<String, dynamic> toMap() => {
        'offerMedia': offerMedia,
        'offerOwnerType': offerOwnerType,
        'offerCreationDate': offerCreationDate,
        'offerOwnerId': offerOwnerId,
        'offerType': offerType,
        'likes': likes,
      };

  VideoOffer.fromMap(Map<String, dynamic> offerInfo, String offerId)
      : super.fromMap(offerInfo, offerId);
}
