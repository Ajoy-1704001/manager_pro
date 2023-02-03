import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/navigation.dart';
import 'package:managerpro/widget/large_button.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key, this.isLeading = false, this.ci = 0});
  final bool isLeading;
  final int ci;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  List<String> avatarName = ["a1", "a2", "a3", "a4", "a5", "a6"];
  int currentIndex = 0;
  UserController userController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.ci;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: widget.isLeading
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  LineAwesomeIcons.angle_left,
                  color: ThemeHelper.textColor,
                ))
            : null,
        title: Text(
          "Choose Avatar",
          style: TextStyle(color: ThemeHelper.textColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/elipse.png",
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
              ),
            ),
            CircleAvatar(
              radius: 70,
              child:
                  Image.asset("assets/avatar/${avatarName[currentIndex]}.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Select your profile avatar",
              style: TextStyle(color: ThemeHelper.secondary),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: Get.height * 0.3,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 40,
                // childAspectRatio: 1.5,
                children: [
                  for (int i = 0; i < 6; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      customBorder: CircleBorder(
                          side:
                              BorderSide(color: ThemeHelper.primary, width: 3)),
                      overlayColor:
                          MaterialStateProperty.all(ThemeHelper.primary),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeHelper.primary,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/avatar/${avatarName[i]}.png"),
                            colorFilter: currentIndex == i
                                ? ColorFilter.mode(
                                    ThemeHelper.primary.withOpacity(.6),
                                    BlendMode.darken)
                                : null,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            LargeBtn(
                onClick: () async {
                  if (widget.isLeading) {
                    userController.tempAvatar.value = currentIndex;
                    userController.changeAvatar.value = true;
                    Get.back();
                  } else {
                    userController.saveAvater("$currentIndex");
                  }
                },
                label: "Next"),
          ],
        ),
      ),
    );
  }
}
