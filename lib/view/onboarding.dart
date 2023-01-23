import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentState = 1;
  List<String> title = [
    "Project Management",
    "Team Management",
    "Task Management"
  ];
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState

    final box = GetStorage();
    // box.write("firstTime", 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    DelayedDisplay(
                      slidingBeginOffset: Offset(0, 0.15),
                      delay: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Image.asset(
                          "assets/c1.png",
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0, 0.07),
                      child: Image.asset(
                        "assets/c2.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0, 0.07),
                      child: Image.asset(
                        "assets/c3.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * 0.23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
                    child: Text(
                      title[currentState - 1],
                      style: TextStyle(
                          color: ThemeHelper.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 40,
                                  color: ThemeHelper.textColor),
                              children: [
                            TextSpan(
                                text: currentState == 1
                                    ? "Let's create a "
                                    : currentState == 2
                                        ? "Work more "
                                        : "Manage your "),
                            TextSpan(
                                text: currentState == 1
                                    ? "space"
                                    : currentState == 2
                                        ? "Structured"
                                        : "Tasks",
                                style: TextStyle(
                                    color: ThemeHelper.primary,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: currentState == 1
                                    ? " for your workflows"
                                    : currentState == 2
                                        ? " and Organized 👌"
                                        : " quickly for Results✌")
                          ])),
                    ),
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Layout.allPad, bottom: Layout.allPad - 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          children: [
                            Container(
                              width: currentState == 1 ? 25 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: currentState == 1
                                      ? BorderRadius.circular(10)
                                      : null,
                                  color: currentState == 1
                                      ? ThemeHelper.primary
                                      : ThemeHelper.ancent,
                                  shape: currentState == 1
                                      ? BoxShape.rectangle
                                      : BoxShape.circle),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Container(
                              width: currentState == 2 ? 25 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: currentState == 2
                                      ? BorderRadius.circular(10)
                                      : null,
                                  color: currentState == 2
                                      ? ThemeHelper.primary
                                      : ThemeHelper.ancent,
                                  shape: currentState == 2
                                      ? BoxShape.rectangle
                                      : BoxShape.circle),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Container(
                              width: currentState == 3 ? 25 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: currentState == 3
                                      ? BorderRadius.circular(10)
                                      : null,
                                  color: currentState == 3
                                      ? ThemeHelper.primary
                                      : ThemeHelper.ancent,
                                  shape: currentState == 3
                                      ? BoxShape.rectangle
                                      : BoxShape.circle),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/next_bg.png",
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 40,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Layout.allPad, right: Layout.allPad - 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.to(const Login());
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(fontSize: 18),
                          )),
                      IconButton(
                          onPressed: () {
                            if (currentState == 3) {
                              Get.to(const Login());
                            } else {
                              pageController.animateToPage(currentState,
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 200));
                              setState(() {
                                currentState += 1;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
