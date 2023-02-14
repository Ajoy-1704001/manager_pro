import 'dart:ui';

import 'package:calender_picker/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/model/task.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';

class ProjectTimeline extends StatefulWidget {
  const ProjectTimeline({super.key});

  @override
  State<ProjectTimeline> createState() => _ProjectTimelineState();
}

class _ProjectTimelineState extends State<ProjectTimeline> {
  DateTime dateTime = DateTime.now();
  List<String> timeline = [
    "09 AM",
    "10 AM",
    "11 AM",
    "12 PM",
    "01 PM",
    "02 PM",
    "03 PM",
    "04 PM",
    "05 PM",
    "06 PM",
    "07 PM",
    "08 PM",
    "09 PM",
    "10 PM",
    "11 PM",
    "12 AM",
    "01 AM",
    "02 AM",
    "03 AM",
    "04 AM",
    "05 AM",
    "06 AM",
    "07 AM",
    "08 AM"
  ];
  ProjectController projectController = Get.find();
  DateTime selectDate = DateTime.now();
  int NoofTask = 15;
  bool isLoaded = false;
  String? selectedProject;
  String? selectedProjectId;
  List<Task> tasks = [];
  var taskMap = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedProject = projectController.projects[0].title;
    selectedProjectId = projectController.projects[0].id;
    getData();
  }

  getData() async {
    taskMap.clear();
    tasks = await projectController.getTimeLine(selectedProjectId!, selectDate);
    for (var element in tasks) {
      taskMap[DateFormat("hh a").format(element.startDate!)] = element;
    }
    print(taskMap);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(Layout.allPad),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45.0,
                    width: 160.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeHelper.ancent),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "$selectedProject",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ThemeHelper.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeHelper.ancent),
                        shape: BoxShape.circle),
                    width: 45,
                    height: 45,
                    child: IconButton(
                      iconSize: 16,
                      onPressed: () {
                        showMenu(
                            context: context,
                            position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                            items: [
                              for (int i = 0;
                                  i < projectController.projects.length;
                                  i++)
                                PopupMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectedProject =
                                          projectController.projects[i].title;
                                      selectedProjectId =
                                          projectController.projects[i].id;
                                    });
                                    getData();
                                  },
                                  value: projectController.projects[i].id,
                                  child:
                                      Text(projectController.projects[i].title),
                                )
                            ]);
                      },
                      icon: const Icon(
                        LineAwesomeIcons.angle_down,
                        size: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat("MMMM, dd").format(selectDate) + "✍️",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        "${tasks.length} task today",
                        style: TextStyle(
                          color: ThemeHelper.secondary,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: ThemeHelper.ancent),
                        borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                      onPressed: () {
                        // Get.bottomSheet(
                        //     SfDateRangePicker(
                        //       selectionMode:
                        //           DateRangePickerSelectionMode.range,
                        //       view: DateRangePickerView.month,
                        //       onSelectionChanged: _onSelectionChanged,
                        //     ),
                        //     backgroundColor: Colors.white);
                      },
                      icon: Icon(
                        LineAwesomeIcons.calendar,
                        color: ThemeHelper.textColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: CalenderPicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  daysCount: 20,
                  enableMultiSelection: false,
                  multiSelectionListener: (value) => print(value),
                  selectionColor: ThemeHelper.primary,
                  selectedTextColor: Colors.white,
                  onDateChange: (selectedDate) {
                    setState(() {
                      selectDate = selectedDate;
                      isLoaded = false;
                    });
                    getData();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.blueGrey.shade200,
              ),
              Expanded(
                child: isLoaded
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: timeline.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 80,
                                child: Row(
                                  children: [
                                    Text(
                                      timeline[index],
                                      style: TextStyle(
                                          color: ThemeHelper.textColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    taskMap.containsKey(timeline[index])
                                        ? Container(
                                            // margin: EdgeInsets.only(right:
                                            // taskMap[timeline[index]]
                                            //         .startDate.hour - (taskMap[timeline[index]]
                                            //         .startDate.minute/60)*15

                                            // ),

                                            decoration: BoxDecoration(
                                                color: taskMap[timeline[index]]
                                                            .priority ==
                                                        0
                                                    ? Colors.green.shade300
                                                    : taskMap[timeline[index]]
                                                                .priority ==
                                                            1
                                                        ? Colors.blue.shade300
                                                        : Colors
                                                            .orange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    taskMap[timeline[index]]
                                                        .title,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    "${DateFormat("hh:mm a").format(taskMap[timeline[index]].startDate)} - ${DateFormat("hh:mm a").format(taskMap[timeline[index]].endDate)}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.blueGrey.shade200,
                              )
                            ],
                          );
                        })
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  // different({DateTime? first, DateTime? last}) async {
  //   int data = last!.difference(first!).inDays;
  //   // ignore: avoid_print

  //   setState(() {
  //     data++;
  //     days = data;
  //     // ignore: avoid_print
  //     print(data);
  //   });
  // }

}
