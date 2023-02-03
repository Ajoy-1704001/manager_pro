import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/controller/task_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/model/task.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/view/add_task.dart';
import 'package:managerpro/view/project_details.dart';
import '../utilities/theme_helper.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  String id = Get.arguments;
  ProjectController controller = Get.find();
  late Project project;
  bool isLoaded = false;
  TaskController taskController = Get.put(TaskController(Get.arguments));
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getProjectDetails();
    taskController.dataFetched.listen((p0) {
      if (p0) {
        taskController.isLoaded.value = true;
      }
    });
  }

  getProjectDetails() async {
    project = await controller.getProjectDetails(id);
    setState(() {
      isLoaded = true;
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
                    padding: const EdgeInsets.all(11),
                    child: Icon(
                      LineAwesomeIcons.angle_left,
                      color: ThemeHelper.textColor,
                    )),
              )),
        ),
        centerTitle: true,
        title: isLoaded
            ? Text(
                project.title,
                style: TextStyle(color: ThemeHelper.textColor),
                overflow: TextOverflow.fade,
                maxLines: 1,
              )
            : LoadingAnimationWidget.prograssiveDots(
                color: ThemeHelper.primary, size: 40),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const ProjectDetails(), arguments: project)!
                    .then((value) {
                  setState(() {
                    isLoaded = false;
                  });
                  getProjectDetails();
                });
              },
              icon: Icon(
                Icons.report,
                color: ThemeHelper.textColor,
              )),
          Container(
            width: 20,
          ),
        ],
      ),
      floatingActionButton: isLoaded
          ? FirebaseAuth.instance.currentUser!.uid == project.managerId
              ? FloatingActionButton(
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.to(const AddTask(), arguments: project);
                  },
                )
              : null
          : null,
      body: Column(
        children: [
          TabBar(
              controller: tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: ThemeHelper.primary, width: 3),
                insets: const EdgeInsets.symmetric(horizontal: 80.0),
              ),
              onTap: (value) => setState(() {}),
              tabs: [
                Tab(
                  child: Text(
                    "Pending Task",
                    style: TextStyle(
                        fontSize: 19,
                        color: tabController!.index == 0
                            ? ThemeHelper.primary
                            : Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    "Completed",
                    style: TextStyle(
                        fontSize: 19,
                        color: tabController!.index == 1
                            ? ThemeHelper.primary
                            : Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
          Obx(() => taskController.isLoaded.value
              ? Expanded(
                  child: TabBarView(controller: tabController, children: [
                    taskController.tasks.isEmpty
                        ? Center(child: Text("No Task Created"))
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Layout.allPad, vertical: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: taskController.tasks.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: ThemeHelper.ancent),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 30),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/code.png",
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${taskController.tasks[index].title}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ThemeHelper
                                                            .primary),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${taskController.tasks[index].description}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        ThemeHelper.textColor),
                                                maxLines: 4,
                                                textAlign: TextAlign.justify,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "${DateFormat("MMM dd").format(taskController.tasks[index].startDate) + "- " + DateFormat("MMM dd").format(taskController.tasks[index].endDate)}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ThemeHelper.primary),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: SizedBox(
                                          height: 80,
                                          width: 3,
                                          child: Container(
                                            color: ThemeHelper.primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                    taskController.comTasks.isEmpty
                        ? Center(child: Text("No Task Created"))
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Layout.allPad, vertical: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: taskController.comTasks.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    alignment: AlignmentDirectional.centerStart,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: ThemeHelper.ancent),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 30),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/code.png",
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${taskController.comTasks[index].title}",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ThemeHelper
                                                            .primary),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${taskController.comTasks[index].description}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        ThemeHelper.textColor),
                                                maxLines: 4,
                                                textAlign: TextAlign.justify,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "${DateFormat("MMM dd").format(taskController.comTasks[index].startDate) + "- " + DateFormat("MMM dd").format(taskController.comTasks[index].endDate)}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ThemeHelper.primary),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: SizedBox(
                                          height: 80,
                                          width: 3,
                                          child: Container(
                                            color: ThemeHelper.primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                  ]),
                )
              : const Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Center(child: CircularProgressIndicator()),
                ))
        ],
      ),
    );
  }
}
