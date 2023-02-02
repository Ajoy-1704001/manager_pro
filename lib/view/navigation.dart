import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:managerpro/controller/project_controller.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/add_task.dart';
import 'package:managerpro/view/all_projects.dart';
import 'package:managerpro/view/create_project.dart';
import 'package:managerpro/view/home.dart';
import 'package:managerpro/view/profile.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var views = [
    const Home(),
    const AllProjects(),
    const Home(),
    const Home(),
    const Profile()
  ];
  int currentIndex = 0;
  UserController userController = Get.put(UserController());
  ProjectController projectController = Get.put(ProjectController());
  TextEditingController codeTextController = TextEditingController();
  bool isLoaded = false;
  late OverlayEntry loader;

  @override
  void initState() {
    super.initState();
    loader = Loader.overlayLoader(context);
    getData();
  }

  Future getData() async {
    await userController.getUserData().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? views[currentIndex]
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar:
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
        BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (value) {
              if (value != 2) {
                setState(() {
                  currentIndex = value;
                });
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/home.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/home_s.png",
                    height: 26,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/projects.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/projects_s.png",
                    height: 26,
                  ),
                  label: "Projects"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/home.png",
                    height: 24,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/home_s.png",
                    height: 24,
                  ),
                  label: "Dummy"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/timeline.png",
                    height: 24,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/timeline_s.png",
                    height: 24,
                  ),
                  label: "Timeline"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/profile.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/profile_s.png",
                    height: 26,
                  ),
                  label: "Profile"),
            ]),
        Positioned(
          top: 5,
          left: (MediaQuery.of(context).size.width / 2) - 25,
          child: InkWell(
            key: const Key("main_fab"),
            onTap: () {
              Get.bottomSheet(
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Layout.allPad, vertical: 20),
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: ThemeHelper.ancent,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/createProject.png",
                              width: 25,
                            ),
                            title: const Text(
                              "Create Project",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              Get.to(const CreateProject());
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ThemeHelper.ancent)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ListTile(
                          //   onTap: () => Get.to(const AddTask()),
                          //   leading: Image.asset(
                          //     "assets/createTask.png",
                          //     width: 25,
                          //   ),
                          //   title: const Text(
                          //     "Create Task",
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(15),
                          //       side: BorderSide(color: ThemeHelper.ancent)),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          ListTile(
                            key: const Key('join_project'),
                            onTap: () {
                              Get.back();
                              Get.dialog(
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Enter invitation code",
                                                style: TextStyle(
                                                    color:
                                                        ThemeHelper.textColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextField(
                                                key: const Key("code"),
                                                controller: codeTextController,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text("Cancel")),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    key: const Key("join"),
                                                    onTap: () async {
                                                      if (codeTextController
                                                          .value.text.isEmpty) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please enter code");
                                                      } else {
                                                        Overlay.of(context)!
                                                            .insert(loader);
                                                        await projectController
                                                            .joinProject(
                                                                codeTextController
                                                                    .value.text,
                                                                userController
                                                                    .avatar
                                                                    .value,
                                                                userController
                                                                    .userName
                                                                    .value);
                                                        loader.remove();
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: ThemeHelper
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12,
                                                                vertical: 5),
                                                        child: Text(
                                                          "Join team",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  transitionCurve: Curves.bounceIn,
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  barrierDismissible: false);
                            },
                            leading: Image.asset(
                              "assets/join.png",
                              width: 25,
                            ),
                            title: const Text(
                              "Join Project",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ThemeHelper.ancent)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeHelper.primary),
                                child: const Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeHelper.primary),
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
          ),
        )
      ]),
    );
  }
}
