import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/avatar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  Project project = Get.arguments;
  ProjectController controller = Get.find();
  bool isLoaded = false;
  String code = "";
  List<MemberDetails> avatars = [];
  @override
  void initState() {
    super.initState();
    code = project.code;
    getUserData();
  }

  getUserData() async {
    avatars = await controller.getMemberDetails(project.members);
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
        title: Text(
          "Project Details",
          style: TextStyle(color: ThemeHelper.textColor),
          overflow: TextOverflow.fade,
          maxLines: 1,
        ),
        actions: [
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.report,
          //       color: ThemeHelper.textColor,
          //     )),
          // Container(
          //   width: 20,
          // ),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: code));
                Fluttertoast.showToast(msg: "Coppied Successfully");
              },
              child: Text(
                code,
                style: TextStyle(
                    color: ThemeHelper.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 28),
              ),
            ),
            project.managerId == FirebaseAuth.instance.currentUser!.uid
                ? InkWell(
                    onTap: () async {
                      var val = await controller.changeCode(project.id);
                      print(val);
                      setState(() {
                        code = val;
                      });
                    },
                    child: Text(
                      "Change Invitation Code",
                      style: TextStyle(color: ThemeHelper.secondary),
                    ),
                  )
                : Text(
                    "Invitation Code",
                    style: TextStyle(color: ThemeHelper.secondary),
                  ),
            const SizedBox(
              height: 20,
            ),
            CircularStepProgressIndicator(
              totalSteps: project.totalTask == 0 ? 1 : project.totalTask,
              currentStep: project.taskCompleted,
              stepSize: 10,
              selectedColor: Colors.green,
              unselectedColor: ThemeHelper.primary,
              padding: 0,
              width: 150,
              height: 150,
              selectedStepSize: 15,
              roundedCap: (_, __) => true,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: ThemeHelper.primary, shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("To Do"),
                const SizedBox(
                  width: 60,
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Completed")
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Team Members",
              style: TextStyle(color: ThemeHelper.textColor, fontSize: 19),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoaded
                ? project.members.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text("No Members Found"),
                      )
                    : SizedBox(
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              itemCount: project.members.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: ThemeHelper.ancent)),
                                        child: Image.asset(
                                          "assets/avatar/a${int.parse(avatars[i].avatar)+1}.png",
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
                                          "${avatars[i].name}",
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )
                : Container()
          ],
        ),
      ),
    );
  }
}
