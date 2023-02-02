import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  String status;
  int priority;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.priority});

  Task.fromDocumentSnapshot(QueryDocumentSnapshot<Object?> doc)
      : id = doc.id,
        title = doc.get('title'),
        description = doc.get('description'),
        startDate = doc.get('startDate').toDate(),
        endDate = doc.get('endDate').toDate(),
        status = doc.get('status'),
        priority = doc.get('priority');

  Map<String, dynamic> toDocumentMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'priority': priority,
    };
  }
}
