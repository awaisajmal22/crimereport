import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/components/constant/loading_dialog.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/home_screen/component/comment_bottom_sheet.dart';
import 'package:iuvo/view/home_screen/controller/home_controller.dart';
import 'package:iuvo/view/home_screen/model/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool like1 = true;
  bool like2 = true;
  bool follow1 = false;
  bool follow2 = false;
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Obx(() => controller.isShowBottomSheet == true
          ? commentBottomSheet(controller: controller, context: context)
          : const SizedBox.shrink()),
      body: Obx(
        () => controller.loadingData.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: width * 0.04),
                child: Column(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            offset: const Offset(-2, 2),
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 7,
                            spreadRadius: 5)
                      ]),
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.04, horizontal: width * 0.04),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              controller.userModel.value.image!.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          controller.userModel.value.image!),
                                    )
                                  : const CircleAvatar(
                                      backgroundImage:
                                          AssetImage(Assets.imageAvater),
                                    ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                width: width * 0.65,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.grey)),
                                child: TextField(
                                  controller: controller.postController,
                                  decoration: const InputDecoration(
                                    hintText: "Share Your Thoughts",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showLoadingIndicator(context: context);
                                  await controller
                                      .addPost(
                                          userImage: controller
                                                  .userModel.value.image ??
                                              '',
                                          name:
                                              controller.userModel.value.name ??
                                                  '',
                                          context: context,
                                          post: controller.postController.text,
                                          image: controller.pickedImage.value,
                                          email: controller.email.value)
                                      .whenComplete(() {
                                    controller.postController.clear();
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.020,
                                      vertical: height * 0.010),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.4),
                                      )),
                                  child: const Icon(Icons.send),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: width * 0.02),
                            child: const Divider(
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  controller.pickPostImage();
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Assets.imagePicture,
                                      scale: 18,
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Text(
                                      "Images",
                                      style: TextStyle(fontSize: width * 0.05),
                                    )
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //     height: width * 0.08,
                              //     child: const VerticalDivider(
                              //       thickness: 1.5,
                              //     )),
                              // InkWell(
                              //   onTap: () async {
                              //     final ImagePicker _picker = ImagePicker();
                              //     final XFile? image = await _picker.pickImage(
                              //         source: ImageSource.gallery);
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Image.asset(
                              //         Assets.imageMultimedia,
                              //         scale: 18,
                              //       ),
                              //       SizedBox(
                              //         width: width * 0.04,
                              //       ),
                              //       Text(
                              //         "Videos",
                              //         style: TextStyle(fontSize: width * 0.05),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: controller.postsList.isEmpty
                          ? const Center(
                              child: Text("No Post Yet."),
                            )
                          : ListView.builder(
                              controller: controller.scrollController,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.postsList.length,
                              itemBuilder: (context, index) {
                                // bool isLike = 
                                print("Current User id ${controller.uid.value}");
                                PostModel post = controller.postsList[index];
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: width * 0.04,
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: post.userImage == '' ||
                                                post.userImage == null
                                            ? const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                Assets.imageAvater,
                                              ))
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    post.userImage!)),
                                        title: Row(
                                          children: [
                                            Text(post.name!),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            // Image.asset(
                                            //   Assets.imagePakistan,
                                            //   scale: 25,
                                            // ),
                                          ],
                                        ),
                                        subtitle: Text(timeago.format(
                                            DateTime.parse(post.dateTime!))),
                                        // trailing: InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       follow1 = !follow1;
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         vertical: width * 0.01,
                                        //         horizontal: width * 0.04),
                                        //     decoration: BoxDecoration(
                                        //         color: follow1
                                        //             ? appThemeColor
                                        //             : Colors.white,
                                        //         border:
                                        //             Border.all(color: appThemeColor),
                                        //         borderRadius:
                                        //             BorderRadius.circular(50)),
                                        //     child: Text(
                                        //       "Follow",
                                        //       style: TextStyle(
                                        //           color: follow1
                                        //               ? Colors.white
                                        //               : appThemeColor),
                                        //     ),
                                        //   ),
                                        // )
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05),
                                      color: Colors.white,
                                      alignment: Alignment.topLeft,
                                      child: Text(post.post!),
                                    ),
                                    SizedBox(
                                      height: width * 0.02,
                                    ),
                                    post.imageUrl == ''
                                        ? const SizedBox.shrink()
                                        : Image.network(post.imageUrl!
                                            // Assets.imageJustices
                                            ),
                                    Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: width * 0.04,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap:  post.likeUnlike!.uid!.contains(controller.uid.value)
                                                      ? (){} : () {
                                              // setState(() {
                                              //   like1 = !like1;
                                              // });
                                              controller.likeDislike(
                                                  postDateTime: post.dateTime!,
                                                  isLike: true);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                 post.likeUnlike!.uid!.contains(controller.uid.value)
                                                      ? Assets.imageFillArrow
                                                      : Assets.imageArrow,
                                                  scale: 23,
                                                ),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Text(
                                                  post.likeUnlike!.like
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: width * 0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap:!post.likeUnlike!.uid!.contains(controller.uid.value)
                                                      ? (){} : () {
                                              // setState(() {
                                              //   like1 = !like1;
                                              // });
                                              controller.likeDislike(
                                                  postDateTime: post.dateTime!,
                                                  isLike: false);
                                            },
                                            child: Row(
                                              children: [
                                                RotatedBox(
                                                    quarterTurns: 90,
                                                    child: Image.asset(
                                                    ! post.likeUnlike!.uid!.contains(controller.uid.value)
                                                      
                                                          ? Assets
                                                              .imageFillArrow
                                                          : Assets.imageArrow,
                                                      scale: 23,
                                                    )),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Text(
                                                  post.likeUnlike!.unlike
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: width * 0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.showBottomSheet(true);
                                              controller.changeSelectedPostIndex(index);
                                              controller.getComments(
                                                  postDateTime: post.dateTime!);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  Assets.imageComment,
                                                  scale: 23,
                                                ),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                Text(
                                                  post.likeUnlike!.comment
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: width * 0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                    ),
                    // Column(
                    //   children: [
                    //     SizedBox(
                    //       height: width * 0.04,
                    //     ),
                    //     Container(
                    //       color: Colors.white,
                    //       child: ListTile(
                    //           leading: CircleAvatar(
                    //               child: Image.asset(
                    //             Assets.imageAvater,
                    //           )),
                    //           title: Row(
                    //             children: [
                    //               const Text("Anonymous"),
                    //               SizedBox(
                    //                 width: width * 0.04,
                    //               ),
                    //               Image.asset(
                    //                 Assets.imagePakistan,
                    //                 scale: 25,
                    //               ),
                    //             ],
                    //           ),
                    //           subtitle: const Text("Drugs"),
                    //           trailing: InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 follow2 = !follow2;
                    //               });
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(
                    //                   vertical: width * 0.01,
                    //                   horizontal: width * 0.04),
                    //               decoration: BoxDecoration(
                    //                   color: follow2 ? appThemeColor : Colors.white,
                    //                   border: Border.all(color: appThemeColor),
                    //                   borderRadius: BorderRadius.circular(50)),
                    //               child: Text(
                    //                 "Follow",
                    //                 style: TextStyle(
                    //                     color:
                    //                         follow2 ? Colors.white : appThemeColor),
                    //               ),
                    //             ),
                    //           )),
                    //     ),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    //       color: Colors.white,
                    //       alignment: Alignment.topLeft,
                    //       child: const Text("Say No!! To Drugs"),
                    //     ),
                    //     SizedBox(
                    //       height: width * 0.02,
                    //     ),
                    //     Image.asset(Assets.imageDrugs),
                    //     Container(
                    //       color: Colors.white,
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: width * 0.04,
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 like2 = !like2;
                    //               });
                    //             },
                    //             child: Row(
                    //               children: [
                    //                 Image.asset(
                    //                   like2
                    //                       ? Assets.imageFillArrow
                    //                       : Assets.imageArrow,
                    //                   scale: 23,
                    //                 ),
                    //                 SizedBox(
                    //                   width: width * 0.03,
                    //                 ),
                    //                 Text(
                    //                   "1.45K",
                    //                   style: TextStyle(fontSize: width * 0.05),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 like2 = !like2;
                    //               });
                    //             },
                    //             child: Row(
                    //               children: [
                    //                 RotatedBox(
                    //                     quarterTurns: 90,
                    //                     child: Image.asset(
                    //                       !like2
                    //                           ? Assets.imageFillArrow
                    //                           : Assets.imageArrow,
                    //                       scale: 23,
                    //                     )),
                    //                 SizedBox(
                    //                   width: width * 0.03,
                    //                 ),
                    //                 Text(
                    //                   "1.22K",
                    //                   style: TextStyle(fontSize: width * 0.05),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           Row(
                    //             children: [
                    //               Image.asset(
                    //                 Assets.imageComment,
                    //                 scale: 23,
                    //               ),
                    //               SizedBox(
                    //                 width: width * 0.03,
                    //               ),
                    //               Text(
                    //                 "2.31K",
                    //                 style: TextStyle(fontSize: width * 0.05),
                    //               )
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}
