import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AllProjects extends StatefulWidget {
  const AllProjects({super.key, this.isLeading = false});
  final bool isLeading;

  @override
  State<AllProjects> createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  ProjectController projectController = Get.put(ProjectController());
  bool projectLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    projectController.dataFetch.listen((p0) {
      if (p0) {
        projectController.isLoaded.value = true;
      }
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
          "Projects",
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
      body: projectController.isLoaded.value
          ? projectController.projects.isEmpty
              ? const Center(
                  child: Text("Press + to add projects"),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: projectController.projects.length,
                      itemBuilder: (context, index) {
                        double progress = (projectController
                                    .projects[index].taskCompleted /
                                (projectController.projects[index].totalTask ==
                                        0
                                    ? 1
                                    : projectController
                                        .projects[index].totalTask)) *
                            100;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Layout.allPad, vertical: 10),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: ThemeHelper.ancent),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          projectController
                                              .projects[index].title,
                                          style: TextStyle(
                                              color: ThemeHelper.textColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          width: 60,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: progress > 70
                                                    ? Colors.green
                                                    : progress < 30
                                                        ? Colors.orange
                                                        : Colors.blue,
                                              )),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${progress.toInt()}%",
                                              style: TextStyle(
                                                  color: ThemeHelper.textColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      projectController
                                          .projects[index].category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ThemeHelper.secondary,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        // AvatarStack(avatars: avatars)
                                        SizedBox(
                                          width: Get.width * 0.6,
                                          child: StepProgressIndicator(
                                            totalSteps: projectController
                                                        .projects[index]
                                                        .totalTask ==
                                                    0
                                                ? 1
                                                : projectController
                                                    .projects[index].totalTask,
                                            currentStep: projectController
                                                .projects[index].taskCompleted,
                                            size: 8,
                                            padding: 0,
                                            selectedColor: progress > 70
                                                ? Colors.green
                                                : progress < 30
                                                    ? Colors.orange
                                                    : Colors.blue,
                                            unselectedColor: progress > 70
                                                ? Colors.green.shade100
                                                : progress < 30
                                                    ? Colors.orange.shade100
                                                    : Colors.blue.shade100,
                                            roundedEdges:
                                                const Radius.circular(10),
                                          ),
                                        )
                                      ],
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
              child: LoadingAnimationWidget.inkDrop(
                  color: ThemeHelper.primary, size: 50),
            ),
    );
  }
}
