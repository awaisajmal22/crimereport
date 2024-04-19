import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/loading_dialog.dart';
import 'package:iuvo/view/LoginScreen/loginScreen.dart';
import 'package:iuvo/view/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validation_plus/validate.dart';

class Auth {
  static signUp(
      {required String name,
      required String email,
      required String country,
      required BuildContext context,
      required String password,
      required String confirmPassword,
      required File file,
      required bool flag,
      required double width,
      var setLoading}) async {
        showLoadingIndicator(context: context);
    String imageUrl = '';
    if (file != null) {
      final img = file;
      Reference storage = FirebaseStorage.instance.ref().child(
          'profile/[profile-${DateTime.now().microsecondsSinceEpoch.toString()}');
      await storage.putFile(img);
      imageUrl = await storage.getDownloadURL();
    }
    if (flag == false) {
      if (Validate.isValidEmail(email)) {
        if (country != 'Select Your Country') {
          if (Validate.isValidPassword(password)) {
            if (password == confirmPassword) {
              
              FirebaseAuth auth = FirebaseAuth.instance;
              await auth
                  .createUserWithEmailAndPassword(
                      email: email, password: password)
                  .then((value) async {
                // User? user = FirebaseAuth.instance.currentUser;
                var database = FirebaseFirestore.instance.collection("users");
                await database
                    .doc(value.user!.uid)
                    .set({
                      "name": name,
                      "email": email,
                      "country": country,
                      "password": password,
                      "image": imageUrl,
                    })
                    .whenComplete(() async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("email", email);
                      prefs.setString("uid", value.user!.uid);
                      prefs.setString("password", password);
                    })
                    .whenComplete(() => hideOpenDialog(context: context))
                    .whenComplete(() => Get.to(const LoginScreen()))
                    .catchError((e) {
                      hideOpenDialog(context: context);
                      Get.snackbar("Data Storing Failed",
                          "Something went wrong,please check your internet connection",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.symmetric(
                              vertical: width * 0.05,
                              horizontal: width * 0.05));
                    });
              });
            } else {
              Get.snackbar("password not match", "Fill correct password",
                  duration: const Duration(seconds: 5),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.symmetric(
                      vertical: width * 0.05, horizontal: width * 0.05));
            }
          } else {
            Get.snackbar("Incorrect password",
                "Min 6 and Max 12 characters At least one uppercase characterAt least one lowercase characterAt least one numberAt least one special character [@#!%?]",
                duration: const Duration(seconds: 5),
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.symmetric(
                    vertical: width * 0.05, horizontal: width * 0.05));
          }
        } else {
          Get.snackbar("Select Country", "Please select your country",
              duration: const Duration(seconds: 5),
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                  vertical: width * 0.05, horizontal: width * 0.05));
        }
      } else {
        Get.snackbar("Invalid Email", "Please Provide Valid Email",
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
                vertical: width * 0.05, horizontal: width * 0.05));
      }
    } else {
      Get.snackbar("Image Not Found", "Please Select Your Image",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
              vertical: width * 0.05, horizontal: width * 0.05));
    }
  }

  static login(
      {required String email,
      required BuildContext context,
      required String password,
      // var setLoading,
      required double width}) {
    if (Validate.isValidEmail(email)) {
      if (Validate.isValidPassword(password)) {
        showLoadingIndicator(context: context);
        FirebaseAuth auth = FirebaseAuth.instance;
        auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
              print("my UId ${value.user!.uid}");
              hideOpenDialog(context: context);
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("email", email);
              prefs.setString("password", password);
              prefs.setString("uid", value.user!.uid);
              Get.offAll(const MainScreen());
            })
            .whenComplete(() => null)
            .catchError((e) {
              hideOpenDialog(context: context);
              Get.snackbar(
                  "Login Failed", "Please check your email and password",
                  duration: const Duration(seconds: 5),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: EdgeInsets.symmetric(
                      vertical: width * 0.05, horizontal: width * 0.05));
            });
      } else {
        Get.snackbar("Incorrect password",
            "Min 6 and Max 12   At least one uppercase characterAt least one lowercase characterAt least one numberAt least one special character [@#!%?]",
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
                vertical: width * 0.05, horizontal: width * 0.05));
      }
    } else {
      Get.snackbar("Invalid Email", "Please Provide Valid Email",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.symmetric(
              vertical: width * 0.05, horizontal: width * 0.05));
    }
  }
}
