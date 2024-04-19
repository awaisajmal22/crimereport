import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/ReportByAdmin/reports_by_admin_screen.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/LoginScreen/loginScreen.dart';
import 'package:iuvo/view/chat_screen/chat_screen.dart';
import 'package:iuvo/view/discover_group_screen/discover_group_screen.dart';
import 'package:iuvo/view/edit_profile_screen/edit_profile_screen.dart';
import 'package:iuvo/view/home_screen/controller/home_controller.dart';
import 'package:iuvo/view/home_screen/home_screen.dart';
import 'package:iuvo/view/home_screen/model/user_model.dart';
import 'package:iuvo/view/report_status_screen/report_status_screen.dart';
import 'package:iuvo/view/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // DiscoverGroupScreen(),
    ChatScreen(),
    ReportStatusScreen()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getEmail();
    controller.getUsersData();
  }

  final controller = Get.put(HomeController());
  bool dataLoaded = true;
  // User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Rx<UserModel> userModel = UserModel().obs;
  // Future getUsersData() async {
  //   try {
  //     // User? user = FirebaseAuth.instance.currentUser;

  //       final DocumentSnapshot<Map<String, dynamic>> data =
  //           await _firestore.collection('users').doc(_uid).get();
  //       print("Data $data");

  //       if (data.exists) {
  //         var userData = data.data();
  //         userModel.value = UserModel.fromJson(userData!);
  //         setState(() {
  //           dataLoaded = false;
  //         });
  //         print(userModel.value.image);
  //       } else {
  //         print('Document does not exist');
  //       }

  //   } catch (e) {
  //     print('Error getting users data: $e');
  //   }
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//   String _email = '';
// String _uid ='';
//   getEmail() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       _email = pref.getString('email') ?? '';
//       _uid = pref.getString('uid') ?? '';
//     });
//     if (_email != '') {
//       getUsersData();
//     }
//   }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crime Reporting App"),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Icon(Icons.notifications),
        //   )
        // ],
      ),
      drawer: Drawer(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  controller.userModel.value.name ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  controller.userModel.value.email ?? "",
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    //WE CAN ALSO USE .network INSTEAD OF .asset//
                    child: controller.userModel.value.image != null ? Image.network(
                            controller.userModel.value.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            Assets.imageAvater,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                decoration: const BoxDecoration(color: appThemeColor),
              ),
              // const ListTile(
              //   leading: Icon(
              //     Icons.home_filled,
              //   ),
              //   title: Text(
              //     'Home',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () => Get.to(const EditProfileScreen()),
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              controller.userModel.value.email ==
                          "muhammadsulemanch81@gmail.com" ||
                      controller.userModel.value.email == "admin@gmail.com" ||
                      controller.userModel.value.email == "umer@gmail.com"
                  ? ListTile(
                      onTap: () async {
                        Get.to(ReportsByAdminScreen());
                      },
                      leading: const Icon(Icons.report, color: Colors.black87),
                      title: const Text(
                        'Reports',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              ListTile(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("email", "null");
                  prefs.setString("password", "null");
                  prefs.setString("uid", "null");
                  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  await firebaseAuth
                      .signOut()
                      .whenComplete(() => Get.offAll(const LoginScreen()));
                },
                leading: const Icon(Icons.logout, color: Colors.black87),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
            icon: Icons.home_filled,
            backgroundColor: _selectedIndex == 0 ? appThemeColor : Colors.white,
          ),
          // FluidNavBarIcon(
          //   icon: Icons.search,
          //   backgroundColor: _selectedIndex == 1 ? appThemeColor : Colors.white,
          // ),
          FluidNavBarIcon(
            icon: Icons.message,
            backgroundColor: _selectedIndex == 1 ? appThemeColor : Colors.white,
          ),
          FluidNavBarIcon(
            icon: Icons.document_scanner,
            backgroundColor: _selectedIndex == 2 ? appThemeColor : Colors.white,
          ),
        ],
        onChange: _onItemTapped,
        style: const FluidNavBarStyle(
            barBackgroundColor: Colors.white,
            iconBackgroundColor: Colors.white,
            iconSelectedForegroundColor: Colors.white,
            iconUnselectedForegroundColor: Colors.grey),
      ),
    );
  }
}
