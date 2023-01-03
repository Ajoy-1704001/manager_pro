import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:managerpro/view/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          Text("Happy New Year!!!!!!!!!!!!!"),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                final box = GetStorage();
                box.write("oldUser", 0);
                Get.offAll(const Login());
              },
              child: Text("Log Out"))
        ],
      )),
    );
  }
}
