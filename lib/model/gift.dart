import 'package:cloud_firestore/cloud_firestore.dart';

class Gift {
  String? id;
  List<String>? productNames;
  String? from;
  String? to;
  DateTime? date;

  Gift({
    required this.id,
    required this.productNames,
    required this.from,
    required this.to,
    required this.date,
  });

  Gift.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    this.date = (map['date'] as Timestamp).toDate();
    this.from = map['from'];
    this.to = map['to'];
    this.productNames = (map['productNames'] as List<dynamic>).map((name) => name.toString()).toList();
  }


  Map<String, dynamic > toMap() => {
    'id': id,
    'date': date,
    'from': from,
    'to': to,
    'productNames': productNames,
  };
}
