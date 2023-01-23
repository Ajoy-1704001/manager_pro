import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:managerpro/utilities/theme_helper.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.ancent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, ),
        ),
        trailing: const Icon(
          LineAwesomeIcons.angle_right,
          size: 16.0,
          color: Colors.black,
        ),
        onTap: onClick,
      ),
    );
  }
}
