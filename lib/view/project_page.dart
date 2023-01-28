import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/view/project_details.dart';
import '../utilities/theme_helper.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String id = Get.arguments;
  ProjectController controller = Get.find();
  late Project project;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getProjectDetails();
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
    );
  }
}
