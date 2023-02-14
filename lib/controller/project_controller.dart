import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/model/task.dart';

class ProjectController extends GetxController {
  var reload = false.obs;
  var dataFetch = false.obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final projects = <Project>[].obs;
  final avatars = <List<MemberDetails>>[].obs;
  var isLoaded = false.obs;
  var assignLoaded = false.obs;
  @override
  void onInit() {
    super.onInit();
    projects.bindStream(getProjects());
  }

  Stream<List<Project>> getProjects() {
    Stream<DocumentSnapshot> stream =
        db.collection('users').doc(auth.currentUser!.uid).snapshots();
    stream.listen((event) async {
      projects.clear();
      avatars.clear();
      dataFetch.value = false;
      isLoaded.value = false;
      try {
        List<dynamic> ids = event.get('projects');
        for (var element in ids) {
          projects.add(Project.fromDocumentSnapshot(
              await db.collection("projects").doc(element).get()));
        }
        projects.value = projects.reversed.toList();
        for (var e in projects) {
          avatars.add(await getMemberDetails(e.members));
        }
      } catch (e) {
        isLoaded.value = true;
      }
      print("data fetched");
      print(avatars.length);
      dataFetch.value = true;
    });
    return projects.stream;
  }

  Future<void> createProject(
      String title,
      String desc,
      String category,
      String dateRange,
      DateTime start,
      DateTime end,
      String avatar,
      String username) async {
    await db.collection("projects").add({
      "title": title,
      "description": desc,
      "category": category,
      "managerId": auth.currentUser!.uid,
      "dateRange": dateRange,
      "start": start,
      "end": end,
      "totalTask": 0,
      "taskCompleted": 0,
      "code": getRandString(8),
      "members": FieldValue.arrayUnion([auth.currentUser!.uid])
    }).then((value) async {
      await db.collection("users").doc(auth.currentUser!.uid).update({
        "projects": FieldValue.arrayUnion([value.id])
      });
    });
    reload.value = false;
    Get.back();
    Get.back();
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<List<Project>> getAllProjects() async {
    List<Project> all_projects = [];
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        List<dynamic> ids = value.get("projects");
        for (var element in ids) {
          projects.add(Project.fromDocumentSnapshot(
              await db.collection("projects").doc(element).get()));
          print(element);
        }
        all_projects = projects.reversed.toList();
      });
    } catch (e) {
      print(e);
    }
    return projects;
  }

  Future<Project> getProjectDetails(String id) async {
    return Project.fromDocumentSnapshot(
        await db.collection("projects").doc(id).get());
  }

  Future<String> changeCode(String? id) async {
    String val = getRandString(8);
    await db.collection("projects").doc(id).update({"code": val});
    return val;
  }

  Future joinProject(String code, String avatar, String username) async {
    await db
        .collection("projects")
        .where("code", isEqualTo: code)
        .where("managerId", isNotEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await db.collection("projects").doc(value.docs[0].id).update({
          "members": FieldValue.arrayUnion([auth.currentUser!.uid])
        });
        await db.collection("users").doc(auth.currentUser!.uid).update({
          "projects": FieldValue.arrayUnion([value.docs[0].id])
        });
        reload.value = false;
        Get.back();
      } else {
        Fluttertoast.showToast(msg: "Invalid Code. Try Again");
      }
    });
  }

  Future<List<MemberDetails>> getMemberDetails(List<String> ids) async {
    List<MemberDetails> members = [];
    for (var element in ids) {
      members.add(MemberDetails.fromDocumentSnapshot(
          await db.collection("users").doc(element).get()));
    }
    return members;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyTasks() {
    // List<Task> tasks = [];
    return db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("tasks")
        .snapshots();
    // return tasks;
  }

  Future<List<Task>> getTimeLine(String id, DateTime selectedDate) async {
    List<Task> timeline = [];
    await db
        .collection("projects")
        .doc(id)
        .collection('tasks')
        .where("stringDate",
            isEqualTo: DateFormat("dd/MM/yyyy").format(selectedDate))
        .get()
        .then((value) async {
      var dataSnapshots = value.docs;
      for (var element in dataSnapshots) {
        timeline.add(Task.fromQueryDocumentSnapshot(element));
      }
    });
    return timeline;
  }
}
