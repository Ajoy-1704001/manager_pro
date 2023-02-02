import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/task_controller.dart';
import 'package:managerpro/model/project.dart';
import 'package:managerpro/model/task.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final formKey = GlobalKey<FormState>();
  int priority = 0;
  List<String> priorityText = ["Low", "Medium", "High"];
  Project project = Get.arguments;
  String title = "", description = "", startDate = "", endDate = "";
  late DateTime start, end;
  TextEditingController d1 = TextEditingController();
  TextEditingController d2 = TextEditingController();
  late OverlayEntry loader;
  TaskController taskController = Get.find();
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
          "Add Task",
          style: TextStyle(
              color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Layout.allPad),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeHelper.secondary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (newValue) => title = newValue!,
                  validator: (value) =>
                      value!.trim().isEmpty ? "Enter Task Name" : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Task Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeHelper.secondary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 3,
                  onSaved: (newValue) => description = newValue!,
                  validator: (value) =>
                      value!.trim().isEmpty ? "Enter Task Description" : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeHelper.secondary,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: d1,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                LineAwesomeIcons.calendar,
                                color: Colors.blueGrey.shade300,
                              ),
                              hintText: "DD/MM/YYYY",
                            ),
                            onSaved: (newValue) => startDate = newValue!,
                            validator: (value) =>
                                value!.isEmpty ? "Select Start Date" : null,
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                setState(() {
                                  start = value!;
                                  startDate =
                                      DateFormat("dd/MM/yyyy").format(start);
                                  d1.text = startDate;
                                });
                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(msg: "Select Date");
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "End Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeHelper.secondary,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: d2,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                LineAwesomeIcons.calendar,
                                color: Colors.blueGrey.shade300,
                              ),
                              hintText: "DD/MM/YYYY",
                            ),
                            onSaved: (newValue) => endDate = newValue!,
                            validator: (value) =>
                                value!.isEmpty ? "Enter Ending Date" : null,
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              ).then((value) {
                                setState(() {
                                  end = value!;
                                  endDate =
                                      DateFormat("dd/MM/yyyy").format(end);
                                  d2.text = endDate;
                                });
                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(msg: "Select Date");
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Priority",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeHelper.secondary,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              priority = i;
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: priority == i
                                        ? ThemeHelper.primary
                                        : ThemeHelper.ancent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(priorityText[i])),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: LargeBtn(
                    label: "Save",
                    onClick: () async {
                      print("hello");
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        Overlay.of(context)!.insert(loader);
                        Task task = Task(
                            title: title,
                            description: description,
                            startDate: start,
                            endDate: end,
                            priority: priority,
                            status: "pending");
                        await taskController.addTask(task, project.id);
                        loader.remove();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
