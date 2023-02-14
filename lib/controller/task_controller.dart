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
  final taskData = Task().obs;
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
    Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        db.collection('projects').doc(id).collection("tasks").snapshots();
    stream.listen((event) {
      dataFetched.value = false;

      _tasks.clear();
      _comTasks.clear();
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        List<dynamic> assignedMembers = element.get("members") ?? [];
        if (assignedMembers.contains(auth.currentUser!.uid)) {
          if (element.get("status") == "pending") {
            _tasks.add(Task.fromDocumentSnapshot(element));
          } else {
            _comTasks.add(Task.fromDocumentSnapshot(element));
          }
        }
      }
      dataFetched.value = true;
      print("task got");
    });
    return _tasks.stream;
  }

  Future addTask(Task task, String? id) async {
    task.members = [auth.currentUser!.uid];
    await db
        .collection("projects")
        .doc(id)
        .collection("tasks")
        .add(task.toDocumentMap())
        .then((value) async {
      await db
          .collection("projects")
          .doc(id)
          .update({"totalTask": FieldValue.increment(1)});
      Get.back();
    });
  }

  Future assignTask(String projectId, String taskId, List<String> ids) async {
    await db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .update({"members": ids}).then((value) async {
      for (var element in ids) {
        await db.collection("users").doc(element).collection("tasks").add({
          "taskId": taskId,
          "projectId": projectId,
        });
      }
      Get.back();
    });
  }

  Stream<Task> getTaskDetails(String projectId, String taskId) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> st = db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .snapshots();
    st.listen((event) {
      taskData.value = Task.fromDocumentSnapshot(event);
    });
    return taskData.stream;
  }

  Future taskResubmit(String projectId, String taskId) async {
    return await db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .update({"review": false});
  }

  Future taskSubmit(String projectId, String taskId) async {
    return await db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .update({"review": true});
  }

  Future taskApprove(String projectId, String taskId) async {
    return await db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .update({"status": "completed"});
  }

  Future taskTotalInc(String projectId) async {
    await db
        .collection("projects")
        .doc(id)
        .update({"taskCompleted": FieldValue.increment(1)});
    Get.back();
  }

  Future taskReject(String projectId, String taskId) async {
    return await db
        .collection("projects")
        .doc(projectId)
        .collection("tasks")
        .doc(taskId)
        .update({"review": false});
  }
}
