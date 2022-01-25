import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/model/offer.dart';

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

  static List<Offer> filterPrices(
      List<Offer> offers, double minPrice, double maxPrice) {
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

  static List<Offer> filterCategories(
      List<Offer> offers, List<String> categories) {
    List<String> offersToRemove = [];
    print(categories);

    for (var offer in offers) {
      if (offer.offerType == OfferType.Product.toString()) {
        ProductOffer p = offer as ProductOffer;
        bool isThereMatch = false;
        print('${p.id} ${p.categories}');

        for (var category in p.categories!) {
          if (categories.contains(category)) {
            isThereMatch = true;
            break;
          }
        }

        if (!isThereMatch) offersToRemove.add(p.id!);
      }
    }

    print(offersToRemove);
    offers.removeWhere((offer) => offersToRemove.contains(offer.id));
    return offers;
  }

  //this function is to convert USD values (actual values on the database) to the currency chosen by user
  static double convertFromUSD(double amount /*USD amount*/) {
    String convertTo = SharedPref.getCurrency();
    print('convert to $convertTo');
    double currencyPriceAgainstDollar = SharedPref.getCurrencyPrice(convertTo);
    print('price is $currencyPriceAgainstDollar');

    //return total amount
    return amount * currencyPriceAgainstDollar;
  }

  //this function is to convert NONE USD (value chosen by user) values to the currency used in database USD
  static Future<double> convertToUSD(double amount /*Non USD amount*/) async {
    String convertFrom = SharedPref.getCurrency();
    print('convert from $convertFrom');
    double currencyPriceAgainstDollar = SharedPref.getCurrencyPrice(convertFrom);
    print('price is $currencyPriceAgainstDollar');

    //return total amount
    return amount / currencyPriceAgainstDollar;
  }

}
