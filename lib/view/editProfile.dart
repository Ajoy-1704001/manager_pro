import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/avatar.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.avatar});
  final int avatar;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
  String pass = "";
  String rePass = "";
  UserController userController = Get.find();
  late OverlayEntry loader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.changeAvatar.value = false;
    userController.tempAvatar.value = 0;
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
          "Edit Profile",
          style: TextStyle(
            color: ThemeHelper.textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              print(name);
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Overlay.of(context)!.insert(loader);
                if (name.isNotEmpty) {
                  await userController.updateName(name);
                }
                if (userController.avatar.value !=
                        "${userController.tempAvatar.value}" &&
                    userController.changeAvatar.value) {
                  await userController
                      .updateAvatar(userController.tempAvatar.value);
                }
                if (pass == rePass && pass.isNotEmpty) {
                  await userController.updatePassword(pass);
                }
                loader.remove();
                Get.back();
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Layout.allPad,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child: Image(
                //     width: 180,
                //     height: 160,
                //     image: AssetImage("assets/avatar/a1.png"),
                //   ),
                // ),
                Obx(() => Container(
                    alignment: Alignment.center,
                    height: 180,
                    child: Image(
                      image: userController.changeAvatar.value
                          ? AssetImage(
                              "assets/avatar/a${userController.tempAvatar.value + 1}.png")
                          : AssetImage(
                              "assets/avatar/a${widget.avatar + 1}.png"),
                      fit: BoxFit.cover,
                    ))),
                Positioned(
                  bottom: 0,
                  left: (Get.width * 0.5) + 20,
                  child: IconButton(
                    onPressed: () {
                      Get.to(Avatar(
                        isLeading: true,
                        ci: widget.avatar,
                      ));
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                          color: ThemeHelper.textColor, shape: BoxShape.circle),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Icon(
                            LineAwesomeIcons.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
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
                            "Name",
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
                          onSaved: (newValue) => name = newValue!.trim(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    userController
                                .auth.currentUser!.providerData[0].providerId ==
                            "password"
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "New Password",
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
                                onSaved: (newValue) => pass = newValue!.trim(),
                                obscureText: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    userController
                                .auth.currentUser!.providerData[0].providerId ==
                            "password"
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Retype New Password",
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
                                    rePass = newValue!.trim(),
                                obscureText: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class Formfield extends StatelessWidget {
  const Formfield({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }
}
