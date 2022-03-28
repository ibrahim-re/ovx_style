import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/model/offer.dart';
import 'package:ovx_style/model/product_property.dart';

class OfferHelper {
  //temporary variables to hold property color
  static Color tempColor = Colors.transparent;
  static Map<String, double> shippingCosts = {};

  static List<String> categories = [];

  static updateCategories(String categoryName) {
    categories.contains(categoryName)
        ? categories.remove(categoryName)
        : categories.add(categoryName);
  }

  static List<Offer> filterPrices(List<Offer> offers, double minPrice, double maxPrice) {
    List<String> offersToRemove = [];

    for (var offer in offers) {
      if (offer.offerType == OfferType.Product.toString()) {
        ProductOffer p = offer as ProductOffer;
        bool isInRange = true;

        for (var productProp in p.properties!) {
          for (var size in productProp.sizes!) {
            if (!(size.price! > minPrice && size.price! < maxPrice)) {
              isInRange = false;
              break;
            }
          }

          //check if already found a price not in range, if there is one, no need to continue
          if (!isInRange) break;
        }

        if (!isInRange) offersToRemove.add(p.id!);
      }
    }

    offers.removeWhere((offer) => offersToRemove.contains(offer.id));

    return offers;
  }

  static List<Offer> filterCategories(List<Offer> offers, List<String> categories) {
    List<String> offersToRemove = [];

    for (var offer in offers) {
      if (offer.offerType == OfferType.Product.toString()) {
        ProductOffer p = offer as ProductOffer;
        bool isThereMatch = false;

        for (var category in p.categories!) {
          if (categories.contains(category)) {
            isThereMatch = true;
            break;
          }
        }

        if (!isThereMatch) offersToRemove.add(p.id!);
      }
    }

    offers.removeWhere((offer) => offersToRemove.contains(offer.id));
    return offers;
  }

  //this function is to convert USD values (actual values on the database) to the currency chosen by user
  static double convertFromUSD(dynamic amount /*USD amount*/) {
    String convertTo = SharedPref.getCurrency();

    //already USD don't convert
    if(convertTo == 'USD')
      return double.parse(amount.toStringAsFixed(2));

    double currencyPriceAgainstDollar = SharedPref.getCurrencyPrice(convertTo);
    double total = amount * currencyPriceAgainstDollar;

    //return total amount
    return double.parse(total.toStringAsFixed(2));
  }

  //this function is to convert NONE USD (value chosen by user) values to the currency used in database USD
  static double convertToUSD(double amount /*Non USD amount*/) {
    String convertFrom = SharedPref.getCurrency();

    //already USD don't convert
    if(convertFrom == 'USD')
      return amount;

    double currencyPriceAgainstDollar = SharedPref.getCurrencyPrice(
        convertFrom);
    double total = amount / currencyPriceAgainstDollar;

    //return total amount
    return total;
  }

  static void convertPricesToUSD(List<ProductProperty> properties) {
    for (int i = 0; i < properties.length; i++) {
      for (int j = 0; j < properties[i].sizes!.length; j++) {
        properties[i].sizes![j].price =
            convertToUSD(properties[i].sizes![j].price!);
      }
    }
  }

  static List<Offer> fromDocumentSnapshotToOffer(QuerySnapshot querySnapshot){
    List<Offer> offers = [];

    for (var e in querySnapshot.docs) {
      final data = e.data() as Map<String, dynamic>;
      final offerId = e.id;

      if (data['offerType'] == OfferType.Product.toString()) {
        ProductOffer offer = ProductOffer.fromMap(data, offerId);
        offers.add(offer);
      } else if (data['offerType'] == OfferType.Post.toString()) {
        PostOffer offer = PostOffer.fromMap(data, offerId);
        offers.add(offer);
      } else if (data['offerType'] == OfferType.Image.toString()) {
        ImageOffer offer = ImageOffer.fromMap(data, offerId);
        offers.add(offer);
      } else if (data['offerType'] == OfferType.Video.toString()) {
        VideoOffer offer = VideoOffer.fromMap(data, offerId);
        offers.add(offer);
      }
    }


    return offers;
  }

}
