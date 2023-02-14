import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:managerpro/model/project_file.dart';

class FileController extends GetxController {
  FilePickerResult? result;
  final _files = <String>[].obs;
  List<String> get files => _files;
  set files(List<String> value) => _files.value = value;
  final _projectFiles = <ProjectFile>[].obs;
  final storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
  }

  void pickFiles(String projectId, String taskId) async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      files = result!.files.map((e) => e.path!).toList();
      for (var element in files) {
        File f = File(element);
        await storage
            .ref(f.path.split("/").last)
            .putData(f.readAsBytesSync())
            .then((p0) async {
          var link = await p0.ref.getDownloadURL().then((value) async {
            await db
                .collection("projects")
                .doc(projectId)
                .collection("tasks")
                .doc(taskId)
                .collection("files")
                .add(ProjectFile(
                  name: f.path.split("/").last,
                  url: value,
                  uploadedBy: auth.currentUser!.uid,
                  uploadedAt: Timestamp.now(),
                ).toDocumentMap());
            Fluttertoast.showToast(msg: "File uploaded Successfully");
          });
        });
      }
    } else {
      // User canceled the picker
    }
  }

  Stream getFileDetails(String projectId, String taskId) {
    return db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .collection("files")
        .snapshots();
  }
}
