import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project {
  final String? id;
  final String title;
  final String description;
  final String dateRange;
  final String category;
  final Timestamp start;
  final Timestamp end;
  final String managerId;
  final int totalTask;
  final int taskCompleted;
  final List<String> members;
  final String code;

  Project(
      {this.id,
      required this.title,
      required this.description,
      required this.dateRange,
      required this.category,
      required this.start,
      required this.end,
      required this.managerId,
      required this.totalTask,
      required this.taskCompleted,
      required this.members,
      required this.code});

  Project.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = doc.data()!["title"],
        description = doc.data()!["description"],
        category = doc.data()!["category"],
        start = doc.data()!["start"],
        end = doc.data()!["end"],
        dateRange = doc.data()!["dateRange"],
        managerId = doc.data()!["managerId"],
        totalTask = doc.data()!["totalTask"],
        taskCompleted = doc.data()!["taskCompleted"],
        code = doc.data()!["code"],
        members = doc.data()?["members"] == null
            ? []
            : doc.data()?["members"].cast<String>();
}

class MemberDetails {
  final String id;
  final String name;
  final String avatar;

  MemberDetails({required this.id, required this.name, required this.avatar});

  MemberDetails.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["username"],
        avatar = doc.data()!["avatar"];
}
