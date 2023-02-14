import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/file_controller.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/controller/task_controller.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/model/project_file.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:managerpro/widget/overlay_loader.dart';

import '../model/task.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  UserController userController = Get.find();
  var arguments = Get.arguments;
  ProjectController projectController = Get.find();
  TaskController taskController = Get.put(TaskController(Get.arguments[0]));
  FileController fileController = Get.put(FileController());
  List<MemberDetails> members = [];
  List<MemberDetails> assigned = [];
  bool isLoaded = false;
  var selectionBool = [];
  List<String> selectionIds = [];
  late Task task;
  List<ProjectFile> projectFiles = [];
  bool isFileLoaded = false;
  late OverlayEntry loader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loader = Loader.overlayLoader(context);
    getData();
  }

  void getData() async {
    print("This is my id: ${userController.auth.currentUser!.uid}");
    print("This is my managerid: ${arguments[1]}");
    taskController
        .getTaskDetails(arguments[2], arguments[0])
        .listen((event) async {
      task = event;
      task.members!.removeWhere(
          (element) => element == userController.auth.currentUser!.uid);
      assigned = await projectController.getMemberDetails(task.members!);
      setState(() {
        isLoaded = true;
      });
    });
    getFile();
  }

  void getFile() {
    Stream p = fileController.getFileDetails(arguments[2], arguments[0]);
    p.listen((event) {
      projectFiles.clear();
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        projectFiles.add(ProjectFile.fromDocumentSnapshot(element));
      }
      setState(() {
        isFileLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 10,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeHelper.ancent),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      LineAwesomeIcons.angle_left,
                      color: ThemeHelper.textColor,
                    )),
              )),
        ),
        title: Text(
          "Task Details",
          style: TextStyle(
            color: ThemeHelper.textColor,
          ),
        ),
        centerTitle: true,
      ),
      bottomSheet: isLoaded
          ? task.status == "pending"
              ? Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Layout.allPad,
                        right: Layout.allPad,
                        bottom: 30,
                        top: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        userController.auth.currentUser!.uid != arguments[1] &&
                                task.review!
                            ? Container()
                            : LargeBtn(
                                onClick: () {
                                  fileController.pickFiles(
                                      arguments[2], arguments[0]);
                                },
                                label: "Upload Files"),
                        const SizedBox(
                          height: 15,
                        ),
                        userController.auth.currentUser!.uid == arguments[1] &&
                                task.review!
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Overlay.of(context)!.insert(loader);
                                    taskController.taskReject(
                                        arguments[2], arguments[0]);
                                    loader.remove();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red.shade300),
                                      minimumSize: MaterialStateProperty.all(
                                          const Size(double.infinity, 50))),
                                  child: Text(
                                    "Reject",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(),
                        userController.auth.currentUser!.uid != arguments[1]
                            ? ElevatedButton(
                                onPressed: () async {
                                  Overlay.of(context)!.insert(loader);
                                  if (task.review!) {
                                    await taskController.taskResubmit(
                                        arguments[2], arguments[0]);
                                  } else {
                                    await taskController.taskSubmit(
                                        arguments[2], arguments[0]);
                                  }
                                  loader.remove();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        task.review!
                                            ? Colors.red.shade300
                                            : Colors.green.shade200),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(double.infinity, 50))),
                                child: Text(
                                  task.review!
                                      ? "Resubmit"
                                      : "Submit for review",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  Overlay.of(context)!.insert(loader);
                                  if (task.review!) {
                                    await taskController.taskApprove(
                                        arguments[2], arguments[0]);
                                    await taskController
                                        .taskTotalInc(arguments[2]);
                                    Fluttertoast.showToast(
                                        msg: "Task Submition Approved");
                                  } else {
                                    // taskController.taskReject(
                                    //     arguments[2], arguments[0]);
                                    Fluttertoast.showToast(
                                        msg: "Task is not completed yet");
                                  }
                                  loader.remove();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        task.review!
                                            ? Colors.green.shade200
                                            : Colors.grey),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(double.infinity, 50))),
                                child: Text(
                                  "Approve",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              : null
          : null,
      body: isLoaded
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Layout.allPad, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: TextStyle(
                          color: ThemeHelper.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      task.priority == 0
                          ? "Low Priority"
                          : task.priority == 1
                              ? "Medium Priority"
                              : "High Priority",
                      style: TextStyle(
                          color: ThemeHelper.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: ThemeHelper.ancent)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.timelapse,
                              size: 30,
                              color: ThemeHelper.textColor,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time",
                              style: TextStyle(
                                  color: ThemeHelper.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              DateFormat("hh:mm a").format(task.startDate!),
                              style: TextStyle(
                                  color: ThemeHelper.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeHelper.primary,
                              border: Border.all(color: ThemeHelper.ancent)),
                          child: const Center(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.timelapse,
                              size: 30,
                              color: Colors.white,
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Time",
                              style: TextStyle(
                                  color: ThemeHelper.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              DateFormat("hh:mm a").format(task.endDate!),
                              style: TextStyle(
                                  color: ThemeHelper.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          color: ThemeHelper.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      task.description!,
                      style: TextStyle(
                          color: ThemeHelper.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userController.auth.currentUser!.uid == arguments[1]
                              ? "Assigned To"
                              : "Submit To",
                          style: TextStyle(
                              color: ThemeHelper.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        userController.auth.currentUser!.uid == arguments[1]
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  openDialog();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green.shade400)),
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  "Assign",
                                  style: TextStyle(color: Colors.white),
                                ))
                            : Container()
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isLoaded
                        ? SizedBox(
                            height: 90,
                            child: ListView.builder(
                                itemCount: assigned.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ThemeHelper.ancent)),
                                          child: Image.asset(
                                            "assets/avatar/a${int.parse(assigned[i].avatar) + 1}.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            "${assigned[i].name}",
                                            maxLines: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : LoadingAnimationWidget.prograssiveDots(
                            color: ThemeHelper.primary, size: 20),
                    Text(
                      "Files",
                      style: TextStyle(
                          color: ThemeHelper.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isFileLoaded
                        ? SizedBox(
                            height: 110,
                            child: ListView.builder(
                                itemCount: projectFiles.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ThemeHelper.ancent)),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.file_copy,
                                                size: 50,
                                                color: Colors.blue.shade400),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                "${projectFiles[i].name}",
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : LoadingAnimationWidget.prograssiveDots(
                            color: ThemeHelper.primary, size: 40),
                    const SizedBox(
                      height: 300,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: ThemeHelper.primary, size: 40)),
    );
  }

  void openDialog() async {
    await getMemberData();
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text("Assign Task",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ThemeHelper.primary,
                        fontWeight: FontWeight.w700)),
                titlePadding: const EdgeInsets.only(top: 20),
                content: Wrap(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Select a user to assign the task to",
                          style: TextStyle(
                              color: ThemeHelper.secondary, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(() => projectController.assignLoaded.value
                            ? SizedBox(
                                height: 150,
                                width: 300,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: members.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        Get.back();
                                      },
                                      leading: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage(
                                            "assets/avatar/a${int.parse(members[index].avatar) + 1}.png"),
                                      ),
                                      title: Text(
                                        members[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      trailing: Checkbox(
                                          value: selectionBool[index],
                                          onChanged: (value) {
                                            setState(() {
                                              selectionBool[index] = value!;
                                              if (value) {
                                                selectionIds
                                                    .add(members[index].id);
                                              } else {
                                                if (selectionIds.contains(
                                                    members[index].id)) {
                                                  selectionIds.remove(
                                                      members[index].id);
                                                }
                                              }
                                            });
                                          }),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ))
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: ThemeHelper.primary),
                      )),
                  TextButton(
                      onPressed: () async {
                        if (selectionIds.isNotEmpty) {
                          await taskController.assignTask(
                              arguments[2], arguments[0], selectionIds);
                          setState(() {
                            isLoaded = false;
                          });
                        }
                      },
                      child: Text(
                        "Assign",
                        style: TextStyle(color: ThemeHelper.primary),
                      )),
                ],
                actionsPadding: const EdgeInsets.only(bottom: 25, right: 40));
          });
        });
  }

  Future getMemberData() async {
    var ids = projectController.projects
        .firstWhere((element) => element.id == arguments[2])
        .members;
    ids.removeWhere(
        (element) => element == userController.auth.currentUser!.uid);
    members = await projectController.getMemberDetails(ids);
    selectionBool = List.filled(members.length, false);
    if (members.isNotEmpty) {
      for (var element in task.members!) {
        if (members.any((e) => e.id == element)) {
          selectionBool[members.indexWhere((e) => e.id == element)] = true;
        }
      }
      setState(() {
        print("assigned loaded");
        projectController.assignLoaded.value = true;
      });
    }
  }
}
