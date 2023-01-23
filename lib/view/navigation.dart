import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/home.dart';
import 'package:managerpro/view/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var views = [
    const Home(),
    const Home(),
    const Home(),
    const Home(),
    const Profile()
  ];
  int currentIndex = 0;
  UserController userController = Get.put(UserController());
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ThemeHelper.ancent)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Image.asset(
                              "assets/createTask.png",
                              width: 25,
                            ),
                            title: const Text(
                              "Create Task",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: ThemeHelper.ancent)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
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
