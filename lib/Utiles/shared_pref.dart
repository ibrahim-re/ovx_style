import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ovx_style/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  //shared user data to access it from anywhere inside the app
  static late User currentUser;

  static late SharedPreferences _sharedPreferences;

  static Future init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setUser(User user) async {
    currentUser = user;
    Map<String, dynamic> userInfo = user.toMap();
    String encodedMap = json.encode(userInfo);

    await _sharedPreferences.setString('User Info', encodedMap);
  }

  static User getUser(){
    User user = User(
      profileImage: '',
      id: '',
      userName: '',
      nickName: '',
      userCode: '',
      email: '',
      phoneNumber: '',
      country: '',
      city: '',
      latitude: 0,
      longitude: 0,
      password: '',
      userType: '',
      shortDesc: '',
    );
    String userInfo = _sharedPreferences.getString('User Info') ?? '';

    if (userInfo.isNotEmpty) {
      Map<String, dynamic> decodedMap = json.decode(userInfo);

      user = User.fromMap(decodedMap, decodedMap['id']);
    }

    currentUser = user;
    return user;
  }

  static deleteUser() {
    currentUser = User(
      profileImage: '',
      id: '',
      userName: '',
      nickName: '',
      userCode: '',
      email: '',
      phoneNumber: '',
      country: '',
      city: '',
      latitude: 0,
      longitude: 0,
      password: '',
      userType: '',
      shortDesc: '',
    );
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
