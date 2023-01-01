import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managerpro/utilities/theme_helper.dart';
import 'package:managerpro/view/login.dart';
import 'package:managerpro/view/navigation.dart';
import 'package:managerpro/view/onboarding.dart';
import 'package:managerpro/view/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: ThemeHelper.textColor,
              displayColor: ThemeHelper.textColor,
              fontFamily: GoogleFonts.poppins().fontFamily),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  backgroundColor:
                      MaterialStateProperty.all(ThemeHelper.primary))),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeHelper.ancent))),
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: const Login(),
    );
  }
}
