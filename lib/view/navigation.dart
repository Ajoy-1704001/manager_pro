import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/home.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var views = [
    const Home(),
    const Home(),
    const Home(),
    const Home(),
    const Home()
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[currentIndex],
      bottomNavigationBar:
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
        BottomNavigationBar(
          elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (value) {
              if (value != 2) {
                setState(() {
                  currentIndex = value;
                });
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/home.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/home_s.png",
                    height: 26,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/projects.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/projects_s.png",
                    height: 26,
                  ),
                  label: "Projects"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/home.png",
                    height: 24,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/home_s.png",
                    height: 24,
                  ),
                  label: "Dummy"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/timeline.png",
                    height: 24,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/timeline_s.png",
                    height: 24,
                  ),
                  label: "Timeline"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/navigation/profile.png",
                    height: 26,
                  ),
                  activeIcon: Image.asset(
                    "assets/navigation/profile_s.png",
                    height: 26,
                  ),
                  label: "Profile"),
            ]),
        Positioned(
          top: 5,
          left: (MediaQuery.of(context).size.width / 2) - 25,
          child: InkWell(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeHelper.primary),
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
          ),
        )
      ]),
    );
  }
}
