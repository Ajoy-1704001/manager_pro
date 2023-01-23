import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/forget_password.dart';
import 'package:managerpro/view/registration.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email, password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late OverlayEntry loader;
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    loader = Loader.overlayLoader(context);
    final box = GetStorage();
    box.write("oldUser", 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sign In",
          style: TextStyle(color: ThemeHelper.textColor),
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
                    "Welcome Back",
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
                      "Please Enter your email address and password for Login",
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
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) =>
                                value == "" ? "Please enter a password" : null,
                            onSaved: (newValue) => password = newValue!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "Enter your password",
                            ),
                          )
                        ],
                      )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Get.to(const ForgetPassword());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: ThemeHelper.textColor,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  LargeBtn(
                      onClick: () async {
                        if (formKey.currentState!.validate()) {
                          Overlay.of(context)!.insert(loader);
                          formKey.currentState!.save();
                          await userController.userLoginByEmail(
                              email, password);
                          loader.remove();
                        }
                      },
                      label: "Sign In"),
                  const SizedBox(
                    height: 25,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign In With",
                        style: TextStyle(color: ThemeHelper.secondary),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeHelper.ancent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Image.asset("assets/facebook.png"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          await userController.userLoginByGoogle();
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeHelper.ancent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Image.asset("assets/google.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not Registered yet?",
                        style: TextStyle(color: ThemeHelper.secondary),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Registration()));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: ThemeHelper.primary,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
