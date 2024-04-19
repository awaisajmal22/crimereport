import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/components/widget/iuvotextfield.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/edit_profile_screen/controller/edit_profile_controller.dart';
import 'package:iuvo/view/home_screen/controller/home_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getEmail();
    controller.getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text('Edit Profile'),
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                controller.deleteUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              // ignore: prefer_const_constructors
              child: Text(
                'Delete Profile',
                style: const TextStyle(color: appThemeColor),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: width * 0.07, horizontal: width * 0.04),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      controller.pickProfileImage();
                    },
                    child: controller.userModel.value.image != null ||
                            controller.userModel.value.image != '' &&
                                controller.pickedImage != ''
                        ? CircleAvatar(
                            radius: width * 0.2,
                            child: Image.network(
                                controller.userModel.value.image!))
                        : CircleAvatar(
                            radius: width * 0.2,
                            child: controller.pickedImage != ''
                                ? Image.file(
                                    File(controller.pickedProfileImage))
                                : Image.asset(
                                    Assets.imageAvater,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  IuvoTextField(
                      obscureText: false,
                      controller: controller.nameController,
                      hintText: controller.nameController.text,
                      labelText: "Name"),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: IuvoTextField(
                        obscureText: false,
                        controller: controller.emailController,
                        hintText: controller.emailController.text,
                        labelText: "email"),
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  InkWell(
                    onTap: () => showCountryPicker(
                      context: context,
                      showPhoneCode:
                          true, // optional. Shows phone code before the country name.
                      onSelect: (country) {
                        print('Select country: ${country.displayName}');
                        controller.countryController.text = country.name;
                        setState(() {});
                      },
                    ),
                    child: IgnorePointer(
                      ignoring: true,
                      child: IuvoTextField(
                          obscureText: false,
                          controller: controller.countryController,
                          hintText: controller.countryController.text,
                          labelText: controller.countryController.text),
                    ),
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateProfile(
                          context: context,
                          imageData: controller.pickedProfileImage,
                          name: controller.nameController.text,
                          email: controller.emailController.text,
                          country: controller.countryController.text);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
