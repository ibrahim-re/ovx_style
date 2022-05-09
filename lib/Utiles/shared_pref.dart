import 'dart:convert';
import 'package:ovx_style/Utiles/enums.dart';
import 'package:ovx_style/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static late SharedPreferences _sharedPreferences;

  static Future init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setUser(User user) async {
    Map<String, dynamic> userInfo = user.toMap();
    String encodedMap = json.encode(userInfo);

    await _sharedPreferences.setString('User Info', encodedMap);
  }

  static void addOfferAdded(String offerId){
    User user = getUser();
    user.offersAdded!.add(offerId);
    setUser(user);
  }

  static void deleteOfferAdded(String offerId){
    User user = getUser();
    user.offersAdded!.remove(offerId);
    setUser(user);
  }

  static void addOfferLiked(String offerId){
    User user = getUser();
    user.offersLiked!.add(offerId);
    setUser(user);
  }

  static void deleteOfferLiked(String offerId){
    User user = getUser();
    user.offersLiked!.remove(offerId);
    setUser(user);
  }

  static void addOfferComment(String offerId){
    User user = getUser();
    user.comments!.add(offerId);
    setUser(user);
  }

  static void deleteOfferComment(String offerId){
    User user = getUser();
    user.comments!.remove(offerId);
    setUser(user);
  }

  static void updateCoverImage(String coverImageUrl){
    User user = getUser();
    user.coverImage = coverImageUrl;
    setUser(user);
  }

  static User getUser(){

    try {
      String userInfo = _sharedPreferences.getString('User Info') ?? '';
      Map<String, dynamic> decodedMap = {};
      if(userInfo.isNotEmpty)
        decodedMap = json.decode(userInfo);

      if(decodedMap['userType'] == UserType.Company.toString())
        return CompanyUser.fromMap(decodedMap, decodedMap['id'] ?? '');
      else
        return PersonUser.fromMap(decodedMap, decodedMap['id'] ?? '');
    } catch (e) {
      throw e;
    }
  }

  static String getChatCountries(){

    String userInfo = _sharedPreferences.getString('User Info') ?? '';
    Map<String, dynamic> decodedMap = {};
    if(userInfo.isNotEmpty)
      decodedMap = json.decode(userInfo);
    else return '';

    String countries = decodedMap['chatCountries'];

    return countries;
  }

  static updateChatCountries(String countries){
    User user = getUser();
    user.chatCountries = countries;
    setUser(user);
  }

  static String getStoryCountries(){

    String userInfo = _sharedPreferences.getString('User Info') ?? '';
    Map<String, dynamic> decodedMap = {};
    if(userInfo.isNotEmpty)
      decodedMap = json.decode(userInfo);
    else return '';

    String countries = decodedMap['storyCountries'];

    return countries;

  }

  static updateStoryCountries(String countries){
    User user = getUser();
    user.storyCountries = countries;
    setUser(user);
  }

  static String getPostsCountries(){

    String userInfo = _sharedPreferences.getString('User Info') ?? '';
    Map<String, dynamic> decodedMap = {};
    if(userInfo.isNotEmpty)
      decodedMap = json.decode(userInfo);
    else return '';

    String countries = decodedMap['postsCountries'];

    return countries;

  }

  static updatePostsCountries(String countries){
    User user = getUser();
    user.postsCountries = countries;
    setUser(user);
  }

  static deleteUser() {
    _sharedPreferences.remove('User Info');
  }

  static void setCurrencies(Map<String, double> currencies) async {

    String encodedMap = json.encode(currencies);
    await _sharedPreferences.setString('currencies', encodedMap);
  }

  //this function to get chosen currency price against dollar
  static double getCurrencyPrice(String currency){
    String currencies = _sharedPreferences.getString('currencies') ?? '';
    Map<String, dynamic> decodedMap = json.decode(currencies);
    double price = decodedMap[currency];

    return price;

  }

  static void setCurrency(String currency) async {

    await _sharedPreferences.setString('currency', currency);
  }

  static String getCurrency() {

    String currency = _sharedPreferences.getString('currency') ?? 'USD';

    return currency;
  }



}
