import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:managerpro/controller/user_controller.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:managerpro/widget/overlay_loader.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> formKey = GlobalKey();
  late String username, email, password;
  UserController userController = Get.put(UserController());
  late OverlayEntry loader;
  @override
  void initState() {
    super.initState();
    loader = Loader.overlayLoader(context);
    final box = GetStorage();
    box.write("oldUser", 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Sign Up",
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
            const Text(
              "Create Account",
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
                "Please enter your information and create your account",
                style: TextStyle(color: ThemeHelper.secondary),
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value == "" ? "Please enter your name" : null,
                      onSaved: (newValue) => username = newValue!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value == "" || !(value!.contains('@'))
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            LargeBtn(
                onClick: () async {
                  if (formKey.currentState!.validate()) {
                    Overlay.of(context)!.insert(loader);
                    formKey.currentState!.save();
                    // print(username);
                    // print(email);
                    // print(password);
                    await userController.createAccount(
                        email, password, username);
                    loader.remove();
                  }
                },
                label: "Sign Up"),
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
                  onTap: ()async {await userController.userLoginByGoogle();},
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
                  "Have an account?",
                  style: TextStyle(color: ThemeHelper.secondary),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: ThemeHelper.primary,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
