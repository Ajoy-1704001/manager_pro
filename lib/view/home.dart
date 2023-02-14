import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/controller/task_controller.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/all_projects.dart';
import 'package:managerpro/view/login.dart';
import 'package:managerpro/view/my_tasks.dart';
import 'package:managerpro/view/project_page.dart';
import 'package:managerpro/view/task_view.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../model/task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserController userController = Get.find();
  GlobalKey<ScaffoldState> sKey = GlobalKey();
  ProjectController projectController = Get.put(ProjectController());
  bool taskLoaded = false;
  List<Task> tasks = [];
  bool projectLoaded = false;
  String getGreetings() {
    if (DateTime.now().hour > 5 && DateTime.now().hour < 12) {
      return "Good Morning!";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 16) {
      return "Good Noon!";
    } else if (DateTime.now().hour >= 16 && DateTime.now().hour < 20) {
      return "Good Evening!";
    } else {
      return "Good Night!";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectController.dataFetch.listen((p0) {
      if (p0) {
        print("loaded");
        projectController.isLoaded.value = true;
        getMyTask();
      }
    });
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
      key: sKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight + 10,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
              onPressed: () {
                sKey.currentState!.openDrawer();
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
                  child: Image.asset(
                    "assets/drawer.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_on_outlined,
                color: ThemeHelper.textColor,
              )),
          Container(
            width: 20,
          ),
        ],
        title: Text(
          DateFormat("EEEE, d").format(DateTime.now()),
          style: TextStyle(
              color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.12,
              ),
              Image.asset(
                "assets/app_logo.png",
                height: 80,
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.home,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Home",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(const AllProjects(
                    isLeading: true,
                  ));
                },
                leading: Icon(
                  Icons.folder,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Projects",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(const MyTasks(
                    isLeading: true,
                  ));
                },
                leading: Icon(
                  Icons.task,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "My Tasks",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.settings,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Settings",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              const Spacer(),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  userController.avatar.value = "0";
                  userController.userName = "".obs;
                  userController.email = "".obs;
                  userController.totalCompleted = 0.obs;
                  userController.onGoing = 0.obs;
                  final box = GetStorage();
                  box.write("oldUser", 0);
                  Get.offAll(const Login());
                },
                leading: Icon(
                  Icons.logout,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Log Out",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       FirebaseAuth.instance.signOut();
          //       userController.avatar.value = "0";
          //       userController.userName = "".obs;
          //       userController.email = "".obs;
          //       userController.totalCompleted = 0.obs;
          //       userController.onGoing = 0.obs;
          //       userController.isLoggedIn = false;
          //       final box = GetStorage();
          //       box.write("oldUser", 0);
          //       Get.offAll(const Login());
          //     },
          //     child: Text("Log Out")),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
            child: Stack(
              children: [
                Image.asset(
                  "assets/elipse_1.png",
                  width: Get.width * 0.7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      getGreetings(),
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    Text(userController.userName.value.split(' ')[0] + " 😉",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
              padding: EdgeInsets.only(left: Layout.allPad),
              child: Obx(() => projectController.isLoaded.value
                  ? projectController.projects.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: Text("Press + to add projects"),
                        )
                      : SizedBox(
                          height: 180,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: projectController.projects.length,
                              itemBuilder: (context, index) {
                                print(
                                    "Task completed ${projectController.projects[index].taskCompleted}");
                                int p = projectController
                                            .projects[index].members.length >
                                        3
                                    ? 3
                                    : projectController
                                        .projects[index].members.length;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const ProjectPage(),
                                          arguments: projectController
                                              .projects[index].id);
                                    },
                                    child: Container(
                                      width: Get.width * 0.8,
                                      decoration: BoxDecoration(
                                          border: index == 0
                                              ? null
                                              : Border.all(
                                                  color: ThemeHelper.ancent),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: index == 0
                                              ? ThemeHelper.primary
                                              : Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              projectController
                                                  .projects[index].title,
                                              style: TextStyle(
                                                  color: index == 0
                                                      ? Colors.white
                                                      : ThemeHelper.textColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              projectController
                                                  .projects[index].category,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: index == 0
                                                    ? Colors.white
                                                    : ThemeHelper.secondary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                projectController
                                                        .avatars[index].isEmpty
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: index ==
                                                                        0
                                                                    ? Colors
                                                                        .white
                                                                    : ThemeHelper
                                                                        .ancent,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: ThemeHelper
                                                                .textColor,
                                                          ),
                                                        ),
                                                      )
                                                    : AvatarStack(
                                                        height: 40,
                                                        width: Get.width * 0.3,
                                                        avatars: [
                                                            for (var n = 0;
                                                                n < p;
                                                                n++)
                                                              AssetImage(
                                                                "assets/avatar/a${int.parse(projectController.avatars[index][n].avatar) + 1}.png",
                                                              ),
                                                          ]),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: Get.width * 0.3,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Progress",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            "${projectController.projects[index].taskCompleted}/${projectController.projects[index].totalTask}",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: index == 0
                                                                  ? Colors.white
                                                                  : ThemeHelper
                                                                      .textColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.3,
                                                      child:
                                                          StepProgressIndicator(
                                                        totalSteps: projectController
                                                                    .projects[
                                                                        index]
                                                                    .totalTask ==
                                                                0
                                                            ? 1
                                                            : projectController
                                                                .projects[index]
                                                                .totalTask,
                                                        currentStep:
                                                            projectController
                                                                .projects[index]
                                                                .taskCompleted,
                                                        size: 8,
                                                        padding: 0,
                                                        selectedColor:
                                                            Colors.white,
                                                        unselectedColor:
                                                            ThemeHelper
                                                                .textColor,
                                                        roundedEdges:
                                                            const Radius
                                                                .circular(10),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                  : Align(
                      alignment: Alignment.center,
                      child: LoadingAnimationWidget.prograssiveDots(
                          color: ThemeHelper.primary, size: 70)))),

          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Tasks",
                  style: TextStyle(
                      color: ThemeHelper.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: ThemeHelper.primary,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          taskLoaded
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
                  : Expanded(
                      child: ListView.builder(
                          itemCount: tasks.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Layout.allPad),
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
                                                    color:
                                                        ThemeHelper.textColor,
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
                )
        ],
      ),
    );
  }
}
