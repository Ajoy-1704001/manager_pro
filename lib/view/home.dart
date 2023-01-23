import 'package:avatar_stack/avatar_stack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/login.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserController userController = Get.find();
  GlobalKey<ScaffoldState> sKey = GlobalKey();

  String getGreetings() {
    if (DateTime.now().hour > 5 && DateTime.now().hour < 12) {
      return "Good Morning!";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 16) {
      return "Good Noon!";
    } else if (DateTime.now().hour >= 16 && DateTime.now().hour < 20) {
      return "Good Evening!";
    } else {
      return "Good Night!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: kToolbarHeight + 10,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
              onPressed: () {
                sKey.currentState!.openDrawer();
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
                  child: Image.asset(
                    "assets/drawer.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_on_outlined,
                color: ThemeHelper.textColor,
              )),
          Container(
            width: 20,
          ),
        ],
        title: Text(
          DateFormat("EEEE, d").format(DateTime.now()),
          style: TextStyle(
              color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.12,
              ),
              Image.asset(
                "assets/app_logo.png",
                height: 80,
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.home,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Home",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.folder,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Projects",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.timelapse,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Timeline",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.task,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "My Tasks",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.settings,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Settings",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              const Spacer(),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  userController.avatar.value = "0";
                  userController.userName = "".obs;
                  userController.email = "".obs;
                  userController.totalCompleted = 0.obs;
                  userController.onGoing = 0.obs;
                  final box = GetStorage();
                  box.write("oldUser", 0);
                  Get.offAll(const Login());
                },
                leading: Icon(
                  Icons.logout,
                  color: ThemeHelper.textColor,
                ),
                horizontalTitleGap: 4,
                title: Text(
                  "Log Out",
                  style: TextStyle(color: ThemeHelper.textColor, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       FirebaseAuth.instance.signOut();
          //       userController.avatar.value = "0";
          //       userController.userName = "".obs;
          //       userController.email = "".obs;
          //       userController.totalCompleted = 0.obs;
          //       userController.onGoing = 0.obs;
          //       final box = GetStorage();
          //       box.write("oldUser", 0);
          //       Get.offAll(const Login());
          //     },
          //     child: Text("Log Out")),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
            child: Stack(
              children: [
                Image.asset(
                  "assets/elipse_1.png",
                  width: Get.width * 0.7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      getGreetings(),
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    Text(
                        userController.userName.value.substring(
                            0, 4)+" 😉",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: EdgeInsets.only(left: Layout.allPad),
            child: InkWell(
              onTap: () {},
              child: Container(
                width: Get.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeHelper.primary),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "E-commerce App",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "App Development",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          AvatarStack(
                              height: 40,
                              width: Get.width * 0.3,
                              avatars: [
                                for (var n = 1; n < 4; n++)
                                  AssetImage(
                                    "assets/avatar/a$n.png",
                                  ),
                              ]),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Progress",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    Text(
                                      "10/15",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: Get.width * 0.3,
                                child: StepProgressIndicator(
                                  totalSteps: 15,
                                  currentStep: 10,
                                  size: 8,
                                  padding: 0,
                                  selectedColor: Colors.white,
                                  unselectedColor: ThemeHelper.textColor,
                                  roundedEdges: Radius.circular(10),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
