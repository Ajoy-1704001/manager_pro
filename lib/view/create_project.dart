import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var dropdownValue = "";
  late String title, description, category, timeRange = "DD/MM/YY - DD/MM/YY";
  late DateTimeRange dateTime;
  late DateTime start, end;
  UserController userController = Get.find();
  ProjectController projectController = Get.find();
  late OverlayEntry loader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loader = Loader.overlayLoader(context);
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
          "Add Project",
          style: TextStyle(
              color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Overlay.of(context)!.insert(loader);
                formKey.currentState!.save();
                if (dropdownValue != "" && start != null && end != null) {
                  projectController.reload.value = true;
                  await projectController.createProject(
                      title,
                      description,
                      dropdownValue,
                      timeRange,
                      start,
                      end,
                      userController.avatar.value,
                      userController.userName.value);
                }
                loader.remove();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Project Title",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ThemeHelper.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onSaved: (newValue) => title = newValue!.trim(),
                            validator: (value) => value!.trim().isEmpty
                                ? "Enter a valid title"
                                : null,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ThemeHelper.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onSaved: (newValue) =>
                                description = newValue!.trim(),
                            validator: (value) => value!.trim().isEmpty
                                ? "Enter description of the project"
                                : null,
                            minLines: 3,
                            maxLines: null,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          TextFormField(
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: DropdownButton(
                                value: dropdownValue,
                                underline: Container(),
                                isExpanded: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: ThemeHelper.textColor,
                                    fontSize: 18),
                                items: const [
                                  DropdownMenuItem(
                                    child: Text("Select a category"),
                                    value: "",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("App Development"),
                                    value: "App Development",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Graphics Design"),
                                    value: "Graphics Design",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Product Development"),
                                    value: "Product Development",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Website Development"),
                                    value: "Website Development",
                                  ),
                                ],
                                onChanged: ((value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                })),
                          )
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Time Period",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.secondary,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ThemeHelper.ancent)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            timeRange,
                            style: TextStyle(
                                color: ThemeHelper.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      final DateTimeRange? picked = await showCrDatePicker(
                        context,
                        properties: DatePickerProperties(
                            pickerMode: TouchMode.rangeSelection,
                            firstWeekDay: WeekDay.sunday,
                            initialPickerDate: DateTime.now(),
                            onDateRangeSelected:
                                (DateTime? rangeBegin, DateTime? rangeEnd) {
                              setState(() {
                                start = rangeBegin!;
                                end = rangeEnd!;
                                print(rangeBegin.toIso8601String());
                                print(rangeEnd.toIso8601String());
                              });
                            },
                            padding: const EdgeInsets.all(20)),
                      );
                      if (start != null && end != null) {
                        setState(() {
                          timeRange = DateFormat("dd/MM/yy").format(start) +
                              " - " +
                              DateFormat("dd/MM/yy").format(end);
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: ThemeHelper.ancent),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Icon(
                          Icons.calendar_month,
                          color: ThemeHelper.textColor,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
