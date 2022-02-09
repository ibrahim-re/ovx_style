import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification {
  String? id;
  String? title;
  String? content;
  DateTime? date;

  MyNotification({
    this.id,
    required this.title,
    required this.content,
    required this.date,
});

  MyNotification.fromMap(Map<String, dynamic> map, String id){
    this.id = id;
    this.title = map['title'];
    this.content = map['content'];
    this.date = (map['date'] as Timestamp).toDate();
  }


}