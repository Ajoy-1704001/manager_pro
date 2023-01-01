import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
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
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Onboarding()));
    });
  }
}
