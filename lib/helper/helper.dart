import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:min_id/min_id.dart';

class Helper{

  static void customizeEasyLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.doubleBounce
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 50.0
      ..radius = 10.0
      ..displayDuration = Duration(milliseconds: 1500)
      ..backgroundColor = MyColors.lightBlue
      ..progressColor = MyColors.primaryColor
      ..indicatorColor = MyColors.primaryColor
      ..textColor = MyColors.primaryColor
      ..maskColor = MyColors.red
      ..userInteractions = false
      ..contentPadding = EdgeInsets.symmetric(horizontal: 25, vertical: 16)
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..textStyle = TextStyle(
        color: MyColors.primaryColor,
        fontWeight: FontWeight.w300,
        fontSize: 16,
      );
  }

  //this function generated search possible strings (more than 4 chars) for a string
  List<String> generateSearchStrings(String text) {
    List<String> output = [];
    for (int i = 0; i < text.length; i++) {
      List<String> temp = [text[i]];
      for (int j = i + 1; j < text.length; j++) {
        temp.add(text[j]);
        if(temp.length >= 4)
          output.add(temp.join().toLowerCase());
      }

    }
    print(output);
    return output;
  }

  Future<String> openDatePicker(BuildContext context) async {
    if (Platform.isIOS) {
      String newDate = '';
      await showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoDatePicker(
          backgroundColor: MyColors.grey.withOpacity(0.5),
          onDateTimeChanged: (newD) {
            newDate = DateFormat('dd-MM-yyyy').format(newD);
          },
          initialDateTime: DateTime.now(),
          maximumYear: 2050,
          minimumYear: 1950,
          mode: CupertinoDatePickerMode.date,
        ),
      );
      return newDate;
    } else {
      var newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
        initialDatePickerMode: DatePickerMode.year,
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: MyColors.secondaryColor,
            ),
          ),
          child: child!,
        ),
      );
      if (newDate != null)
        return DateFormat('dd-MM-yyyy').format(newDate);
      else
        return '';
      //setState(() {selectedDate = DateFormat('dd-MM-yyyy').format(newDate);});

    }
  }


  String generateRandomName() {
    String randomText = MinId.getId();

    return randomText;
  }

  String generateRandomNumericId() {
    String randomText = MinId.getId('{5{d}}');

    return randomText;
  }

  double priceAfterDiscount(double oldPrice, double discount){
    double newPrice = oldPrice - (oldPrice * (discount / 100));

    return double.parse(newPrice.toStringAsFixed(2));
  }

  Future<void> sendEmail(String subject, String body, List<String> attachmentsPath) async {
    final Email email = Email(
      attachmentPaths: attachmentsPath,
      body: body,
      subject: subject,
      recipients: ['ovxstyle@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      print('error is $e');
    }
  }

  String getCountryFlag(String country){
    if(country == 'All countries')
      return country;

    return country.replaceAll(RegExp('[A-Za-z0-9]'), '').trim();
  }

  String deleteCountryFlag(String country){
    if(country == 'All countries')
      return country;

    return country.replaceAll(RegExp('[^A-Za-z0-9 ]'), '').trimLeft();
  }

  int getAgeFromBirthDate(String birthDate){

    if(birthDate.isEmpty)
      return 0;

    //get year from string formatted like: 17-07-1995
    int yearOfBirth = int.parse(birthDate.substring(6));
    //get current year
    int currentYear = DateTime.now().year;

    return currentYear - yearOfBirth;
  }

  bool checkBillRequest(DateTime billDate){
    DateTime dayToRequest = billDate.add(Duration(days: 10));
    DateTime now = DateTime.now();

    return now.isAfter(dayToRequest);
  }

}