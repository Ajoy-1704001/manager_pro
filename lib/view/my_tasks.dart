import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/model/task.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/task_view.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key, this.isLeading = false});
  final bool isLeading;

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  ProjectController projectController = Get.find();
  bool taskLoaded = false;
  List<Task> tasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyTask();
  }

  getMyTask() {
    projectController.getMyTasks().listen((event) async {
      List<String> temp = [];
      try {
        event.docs.forEach((element) async {
          await FirebaseFirestore.instance
              .collection("projects")
              .doc(element.data()["projectId"])
              .collection("tasks")
              .doc(element.data()["taskId"])
              .get()
              .then((value) {
            tasks.add(Task.fromDocumentSnapshot(value));
          });
        });
        print("Tasks loaed");
      } catch (e) {
        temp = [];
      }
      tasks.clear();
      print(temp.length);

      print(tasks.length);
      setState(() {
        taskLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          toolbarHeight: kToolbarHeight + 10,
          leadingWidth: 80,
          backgroundColor: Colors.white,
          leading: widget.isLeading
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    LineAwesomeIcons.angle_left,
                    color: ThemeHelper.textColor,
                  ))
              : null,
          title: Text(
            "My Tasks",
            style: TextStyle(
                color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
          ),
          // bottom: PreferredSize(
          //     preferredSize: Size.fromHeight(kToolbarHeight + 30),
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
          //       child: TextField(
          //         decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.search), hintText: "Search"),
          //       ),
          //     )),
        ),
        body: taskLoaded
            ? tasks.isEmpty
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      "No task found",
                      style: TextStyle(
                          color: ThemeHelper.secondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                        itemCount: tasks.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: Layout.allPad),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => const TaskView(), arguments: [
                                  tasks[index].id,
                                  tasks[index].managerId,
                                  tasks[index].projectId!,
                                ]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ThemeHelper.ancent, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tasks[index].projectName!,
                                              style: TextStyle(
                                                color: ThemeHelper.secondary,
                                              ),
                                            ),
                                            Text(
                                              tasks[index].title!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: ThemeHelper.textColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 70,
                                        height: 25,
                                        child: Center(
                                          child: Text(
                                            "Medium",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
            : Center(
                child: LoadingAnimationWidget.prograssiveDots(
                    color: ThemeHelper.primary, size: 40),
              ));
  }
}
