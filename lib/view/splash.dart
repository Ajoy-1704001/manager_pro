import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/avatar.dart';
import 'package:managerpro/view/home.dart';
import 'package:managerpro/view/login.dart';
import 'package:managerpro/view/navigation.dart';
import 'package:managerpro/view/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    onStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: DelayedDisplay(
          delay: const Duration(milliseconds: 100),
          slidingBeginOffset: Offset(0.0, 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/app_logo.png",
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "ManagerPro",
                style: TextStyle(
                    color: ThemeHelper.primary,
                    fontSize: 45,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }

  onStart() {
    final box = GetStorage();
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null && box.read("firstTime") == 1) {
          Get.to(const Login());
        } else if (user != null) {
          print("ki obostha?");
          if (box.read("oldUser") == 1) {
            print('Welcome Back');
            Fluttertoast.showToast(msg: "Welcome back");
            Get.offAll(const Navigation());
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Onboarding()));
        }
      });
    });
  }
}
