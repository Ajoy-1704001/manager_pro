import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/custom_tile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
// String ProfileName = "Ajoy Deb Nath";
  late String avatarName = "a1";
  UserController userController = Get.find();
  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    await userController.getUserData().then((value) {
      setState(() {
        isLoad = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: ThemeHelper.ancent,
        //     ),
        //     borderRadius: BorderRadius.circular(100),
        //   ),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       LineAwesomeIcons.angle_left,
        //       size: 25.0,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        title: Text(
          "Profile",
          style: TextStyle(
              color: ThemeHelper.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoad
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      child: Image.asset("assets/elipse_1.png",
                          height: MediaQuery.of(context).size.height * 0.12),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            child: Image.asset(
                                "assets/avatar/a${userController.avatar.value}.png"),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userController.userName.value,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            userController.email.value,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: ThemeHelper.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              side: BorderSide(
                                color: ThemeHelper.primary,
                              ),
                            ),
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  color: ThemeHelper.textColor, fontSize: 13.0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: [
                                  const Icon(LineAwesomeIcons.clock),
                                  const SizedBox(height: 5),
                                  Text(
                                    userController.onGoing.value.toString(),
                                    style: TextStyle(
                                        color: ThemeHelper.textColor,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "On Going",
                                    style: TextStyle(
                                        color: ThemeHelper.secondary,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(children: [
                                const Icon(LineAwesomeIcons.check_circle),
                                const SizedBox(height: 5),
                                Text(
                                  userController.totalCompleted.value.toString(),
                                  style: TextStyle(
                                      color: ThemeHelper.textColor,
                                      fontSize: 20),
                                ),
                                Text(
                                  "Total Completed",
                                  style: TextStyle(
                                      color: ThemeHelper.secondary,
                                      fontSize: 12),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 25),
                          CustomListTile(
                            title: "My Projects",
                            onClick: () {},
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            title: "Join a Team",
                            onClick: () {},
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            title: "Settings",
                            onClick: () {},
                          ),
                          const SizedBox(height: 10),
                          CustomListTile(
                            title: "My Tasks",
                            onClick: () {},
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: ThemeHelper.primary, size: 60),
            ),
    );
  }
}
