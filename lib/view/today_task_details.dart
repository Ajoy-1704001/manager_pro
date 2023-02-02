import 'dart:ui';

import 'package:calender_picker/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:software/utilities/theme_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class task_details extends StatefulWidget {
  const task_details({super.key});

  @override
  State<task_details> createState() => _task_detailsState();
}

class _task_detailsState extends State<task_details> {
  DateTime dateTime = DateTime.now();
  int days = 10;
  int NoofTask = 15;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      height: 35.0,
                      width: 160.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeHelper.ancent),
                      ),
                      child: Center(
                        child: Text(
                          "E-commerce App",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ThemeHelper.textColor,
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
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: IconButton(
                        onPressed: () {},
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat.MMMMd().format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              LineAwesomeIcons.feather,
                              color: Color.fromARGB(255, 204, 184, 3),
                            )
                          ],
                        ),
                        Text(
                          "$NoofTask task today",
                          style: TextStyle(
                            color: ThemeHelper.secondary,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: ThemeHelper.ancent),
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: () {
                          Get.bottomSheet(
                              SfDateRangePicker(
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                view: DateRangePickerView.month,
                                onSelectionChanged: _onSelectionChanged,
                              ),
                              backgroundColor: Colors.white);
                        },
                        icon: const Icon(
                          LineAwesomeIcons.calendar,
                          color: Color(0XFF0342E9),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 100,
                  child: CalenderPicker(
                    dateTime,
                    daysCount: days,
                    // ignore: avoid_print
                    enableMultiSelection: false,
                    // ignore: avoid_print
                    multiSelectionListener: (value) => print(value),
                    selectionColor: const Color(0XFF0342E9),
                    selectedTextColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  different({DateTime? first, DateTime? last}) async {
    int data = last!.difference(first!).inDays;
    // ignore: avoid_print

    setState(() {
      data++;
      days = data;
      // ignore: avoid_print
      print(data);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      setState(() {
        dateTime = args.value.startDate;

        if (args.value.endDate != null) {
          different(first: args.value.startDate, last: args.value.endDate);
          // ignore: avoid_print
          print(args.value.startDate);
          // ignore: avoid_print
          print(args.value.endDate);
        }
      });
    }
  }
}
