import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/utilities/theme_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

// String ProfileName = "Ajoy Deb Nath";
// String ProfileMail = "u1704001@student.cuet.ac.bd";
// String OngoingProjectNo = "5";
// String TotalCompletedProjectNo = "25";
// String ProfileImage = "assets/avatar/a1.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ThemeHelper.ancent,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              size: 25.0,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: ThemeHelper.textColor, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/elipse.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Image(
                  width: 120,
                  height: 120,
                  image: AssetImage("assets/avatar/a1.png"),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Ajoy Deb Nath",
                style: TextStyle(
                  fontSize: 20.0,
                  color: ThemeHelper.textColor,
                ),
              ),
              Text(
                "u1704001@student.cuet.ac.bd",
                style: TextStyle(
                  fontSize: 13.0,
                  color: ThemeHelper.secondary,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: ThemeHelper.primary,
                  ),
                ),
                child: Text(
                  "Edit",
                  style:
                      TextStyle(color: ThemeHelper.textColor, fontSize: 13.0),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Icon(LineAwesomeIcons.clock),
                        const SizedBox(height: 5),
                        Text(
                          "5",
                          style: TextStyle(
                              color: ThemeHelper.textColor, fontSize: 18),
                        ),
                        Text(
                          "On Going",
                          style: TextStyle(
                              color: ThemeHelper.secondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      Icon(LineAwesomeIcons.check_circle),
                      const SizedBox(height: 5),
                      Text(
                        "25",
                        style: TextStyle(
                            color: ThemeHelper.textColor, fontSize: 20),
                      ),
                      Text(
                        "Total Completed",
                        style: TextStyle(
                            color: ThemeHelper.secondary, fontSize: 12),
                      ),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ProfileList(
                title: "My Projects",
              ),
              const SizedBox(height: 10),
              ProfileList(
                title: "Join a Team",
              ),
              const SizedBox(height: 10),
              ProfileList(
                title: "Settings",
              ),
              const SizedBox(height: 10),
              ProfileList(
                title: "My Tasks",
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  const ProfileList({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.ancent),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: ThemeHelper.textColor, fontSize: 15),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            LineAwesomeIcons.angle_right,
            size: 16.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
