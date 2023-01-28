import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:managerpro/model/project.dart';

class ProjectController extends GetxController {
  var reload = false.obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
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

  Future<List<Project>> getProjects() async {
    List<Project> projects = [];
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
        projects = projects.reversed.toList();
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
}
