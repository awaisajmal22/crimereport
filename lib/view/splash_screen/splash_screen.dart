import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/get_start_screen/report_your_issue_screen.dart';
import 'package:iuvo/view/main_screen/main_screen.dart';
import 'package:iuvo/view/signUp_screen/signup_screen.dart';
import 'package:iuvo/view/splash_screen/component/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    if (email.toString() != "null" && password.toString() != "null") {
      Get.to(const MainScreen());
    } else {
      Timer(Duration(seconds: 2), () => Get.to(const ReportYourIssueScreen()));
    }
  }

  @override
  void initState() {
    getLogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimationWidget(
              duration: const Duration(milliseconds: 300),
              widget: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  width: MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    'CRASA',
                    style: GoogleFonts.macondo(
                        fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
          ),
          AnimationWidget(
            duration: const Duration(milliseconds: 700),
            widget: Center(
              child: Text(
                "Crime Reporting\nAnd Awareness\nSocial App",
                textAlign: TextAlign.center,
                style: GoogleFonts.macondo(
                  fontWeight: FontWeight.w500,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.080,
          ),
          AnimationWidget(
            duration: const Duration(seconds: 1),
            widget: Center(
              child: Text(
                "Join the community to\nhelp each other and\nreport crimes with\ncomplete safety.",
                textAlign: TextAlign.center,
                style: GoogleFonts.macondo(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
