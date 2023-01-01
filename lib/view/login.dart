import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerpro/utilities/layout.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/widget/large_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: ThemeHelper.ancent))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
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
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: ThemeHelper.textColor,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            LargeBtn(onClick: () {}, label: "Sign In"),
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
                    onPressed: () {},
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
      ),
    );
  }
}
