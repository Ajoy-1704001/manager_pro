import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:managerpro/model/task.dart';

class TaskController extends GetxController {
  final _tasks = <Task>[].obs;
  final _comTasks = <Task>[].obs;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Task> get tasks => _tasks;
  List<Task> get comTasks => _comTasks;
  set tasks(List<Task> value) => _tasks.value = value;
  set comTasks(List<Task> value) => _comTasks.value = value;
  String id = "";
  var isLoaded = false.obs;
  var dataFetched = false.obs;
  TaskController(this.id);
  @override
  void onInit() {
    super.onInit();
    _tasks.bindStream(getTasks());
  }

  Stream<List<Task>> getTasks() {
    print(id);
    Stream<QuerySnapshot> stream =
        db.collection('projects').doc(id).collection("tasks").snapshots();
    stream.listen((event) {
      dataFetched.value = false;
      _tasks.clear();
      _comTasks.clear();
      for (var element in event.docs) {
        if (element.get("status") == "pending") {
          _tasks.add(Task.fromDocumentSnapshot(element));
        } else {
          _comTasks.add(Task.fromDocumentSnapshot(element));
        }
      }
      dataFetched.value = true;
      print("task got");
    });
    return _tasks.stream;
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
