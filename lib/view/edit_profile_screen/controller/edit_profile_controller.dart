import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iuvo/components/constant/loading_dialog.dart';
import 'package:iuvo/view/LoginScreen/loginScreen.dart';
import 'package:iuvo/view/home_screen/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editProfileController extends GetxController {
  RxString email = ''.obs;
  RxString uid = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uid.value = pref.getString("uid") ?? '';
    print("is there uid ${uid.value}");
    email.value = pref.getString('email') ?? '';
    if (uid.value != '') {
      getUsersData();
    }
  }

  RxBool loadingData = true.obs;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rx<UserModel> userModel = UserModel().obs;
  Future getUsersData() async {
    try {
      // User? user = FirebaseAuth.instance.currentUser;
      // if (uid.value != '') {
      final DocumentSnapshot<Map<String, dynamic>> data =
          await _firestore.collection('users').doc(uid.value).get();
      print("useruid ${uid.value}");

      if (data.exists) {
        var userData = data.data();
        userModel.value = UserModel.fromJson(userData!);

        loadingData.value = false;
        print(userModel.value.image);
      } else {
        print('Document does not exist');
      }
      // } else {
      //   print('No user signed in.');
      // }
    } catch (e) {
      print('Error getting users data: $e');
    }
  }

  

  
}
