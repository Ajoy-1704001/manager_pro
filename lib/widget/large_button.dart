import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LargeBtn extends StatelessWidget {
  const LargeBtn({super.key, required this.onClick, required this.label});
  final VoidCallback onClick;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 50))),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
