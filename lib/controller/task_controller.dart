import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:managerpro/model/task.dart';

class TaskController extends GetxController {
  final _tasks = <Task>[].obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Task> get tasks => _tasks;
  set tasks(List<Task> value) => _tasks.value = value;

  @override
  void onInit() {
    super.onInit();
    _tasks.bindStream(getTasks());
  }

  Stream<List<Task>> getTasks() {
    Stream<QuerySnapshot> stream =
        db.collection('projects').doc().collection("tasks").snapshots();

    return stream.map((qShot) =>
        qShot.docs.map((doc) => Task.fromDocumentSnapshot(doc)).toList());
  }

  Future addTask(Task task, String? id) async {
    await db
        .collection("projects")
        .doc(id)
        .collection("tasks")
        .add(task.toDocumentMap())
        .then((value) => Get.back());
  }
}
