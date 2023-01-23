import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get/instance_manager.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserController userController = Get.find();
  late String email;
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
        elevation: 0,
        title: Text(
          "Password Reset",
          style: TextStyle(color: ThemeHelper.textColor),
        ),
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ThemeHelper.ancent),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: ThemeHelper.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Layout.allPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            DelayedDisplay(
              delay: const Duration(milliseconds: 200),
              slidingBeginOffset: const Offset(0.0, 0.20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "Please Enter your email address. A password reset email will be sent to your email.",
                      style: TextStyle(color: ThemeHelper.secondary),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) => !GetUtils.isEmail(value!)
                                ? "Please enter a valid email"
                                : null,
                            onSaved: (newValue) => email = newValue!.trim(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "Enter your email",
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  LargeBtn(
                      onClick: () async {
                        if (formKey.currentState!.validate()) {
                          Overlay.of(context)!.insert(loader);
                          formKey.currentState!.save();
                          await userController.passwordResetLink(email);
                          loader.remove();
                        }
                      },
                      label: "Send Link"),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
