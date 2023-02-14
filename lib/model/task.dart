import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:managerpro/model/project_file.dart';
import 'package:managerpro/view/project_details.dart';

class Task {
  String? id;
  String? projectId;
  String? managerId;
  String? projectName;
  String? title;
  String? description;
  String? stringDate;
  DateTime? date;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  int? priority;
  List<String>? members;
  bool? review;

  Task(
      {this.id,
      this.projectId,
      this.managerId,
      this.projectName,
      this.title,
      this.description,
      this.date,
      this.stringDate,
      this.startDate,
      this.endDate,
      this.status,
      this.priority,
      this.members,
      this.review});

  Task.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>?> doc)
      : id = doc.id,
        projectId = doc.get('projectId'),
        title = doc.get('title'),
        managerId = doc.get('managerId'),
        description = doc.get('description'),
        projectName = doc.get('projectName'),
        stringDate = doc.get('stringDate'),
        date = doc.get('date').toDate(),
        startDate = doc.get('startDate').toDate(),
        endDate = doc.get('endDate').toDate(),
        status = doc.get('status'),
        priority = doc.get('priority'),
        review = doc.get('review'),
        members = doc.data()?["files"] == null
            ? []
            : doc.data()?["members"].cast<String>();

  Task.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>?> doc)
      : id = doc.id,
        projectId = doc.get('projectId'),
        managerId = doc.get('managerId'),
        projectName = doc.get('projectName'),
        title = doc.get('title'),
        description = doc.get('description'),
        stringDate = doc.get('stringDate'),
        date = doc.get('date').toDate(),
        startDate = doc.get('startDate').toDate(),
        endDate = doc.get('endDate').toDate(),
        status = doc.get('status'),
        priority = doc.get('priority'),
        review = doc.get('review'),
        members = doc.data()?["members"] == null
            ? []
            : doc.data()?["members"].cast<String>();

  Map<String, dynamic> toDocumentMap() {
    return {
      'title': title,
      'projectId': projectId,
      'projectName': projectName,
      'managerId': managerId,
      'description': description,
      'stringDate': stringDate,
      'date': date,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'priority': priority,
      'members': members,
      'review': review,
    };
  }
}
