import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iuvo/components/constant/loading_dialog.dart';
import 'package:iuvo/view/LoginScreen/loginScreen.dart';
import 'package:iuvo/view/home_screen/model/comment_model.dart';
import 'package:iuvo/view/home_screen/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post_model.dart';

class HomeController extends GetxController {
  RxBool loadingData = true.obs;
  TextEditingController postController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future addPost(
      {required BuildContext context,
      required String name,
      required String post,
      required String userImage,
      required String image,
      required String email}) async {
    try {
      String imageUrl = '';
      PostModel model = PostModel();
      if (image != '') {
        final img = image;
        Reference storage = FirebaseStorage.instance.ref().child(
            'post/[post-${DateTime.now().microsecondsSinceEpoch.toString()}');
        await storage.putFile(File(img));
        imageUrl = await storage.getDownloadURL();
      }
      model.name = name;
      model.imageUrl = imageUrl;
      model.email = email;
      model.post = post;
      model.userImage = userImage;
      model.dateTime = DateTime.now().toIso8601String();
      model.likeUnlike = LikeUnlike(like: 0, unlike: 0, comment: 0, uid: []);
      _firestore.collection('Posts').doc().set(model.toJson()).whenComplete(() {
        hideOpenDialog(context: context);
        pickedImage.value = '';
      });
    } catch (e) {
      hideOpenDialog(context: context);
    }
  }

  RxString pickedImage = ''.obs;
  pickPostImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image.path;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getEmail();
  getPostData();
    getUsersData();
   
    
    super.onInit();
  }

  RxString email = ''.obs;
RxString uid = ''.obs;
  getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
uid.value = pref.getString("uid") ?? '';
print("is there uid ${uid.value}");
    email.value = pref.getString('email') ?? '';
    if(uid.value != ''){
     getPostData();
    getUsersData();
    }
  }
    TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  //  User? user = FirebaseAuth.instance.currentUser;
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
                  nameController.text = userModel.value.name ?? '';
        emailController.text = userModel.value.email ?? '';
        countryController.text = userModel.value.country ?? '';
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

  RxList<PostModel> postsList = <PostModel>[].obs;

  getPostData() async {
    postsList.clear();
    await _firestore.collection('Posts').snapshots().listen((snapshot) {
      snapshot.docs.forEach((element) {
        var postData = PostModel.fromJson(element.data());
        bool alreadyExists =
            postsList.any((post) => post.dateTime == postData.dateTime);
        if (!alreadyExists) {
          postsList.add(postData);
          postsList.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
        }
      });
    });
  }

  RxBool _isShowBottomSheet = false.obs;
  bool get isShowBottomSheet => _isShowBottomSheet.value;
  showBottomSheet(bool val) {
    _isShowBottomSheet.value = val;
  }

  RxList<CommentModel> commentsList = <CommentModel>[].obs;
  postComment({
    required String postDateTime,
    required String imageUrl,
    required String comment,
    required String name,
  }) async {
    try {
      print("POst DateTime $postDateTime");
      CommentModel commentModel = CommentModel();
      commentModel.name = name;
      commentModel.imageUrl = imageUrl;
      commentModel.comment = comment;
      commentModel.dateTime = DateTime.now().toIso8601String();
      await _firestore
          .collection('comments')
          .doc(postDateTime)
          .collection(postDateTime)
          .doc()
          .set(commentModel.toJson())
          .whenComplete(() async {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('Posts')
            .where('dateTime', isEqualTo: postDateTime)
            .get();

        // Iterate over the documents returned by the query
        querySnapshot.docs.forEach((doc) async {
          PostModel model = PostModel.fromJson(doc.data());
          DocumentReference<Map<String, dynamic>> documentReference =
              doc.reference;

          PostModel newModel = PostModel(
              email: model.email,
              post: model.post,
              name: model.name,
              dateTime: postDateTime,
              userImage: model.userImage,
              imageUrl: model.imageUrl,
              likeUnlike: LikeUnlike(
                  like: model.likeUnlike!.like,
                  unlike: model.likeUnlike!.unlike,
                  comment: model.likeUnlike!.comment! + 1,
                  uid: model.likeUnlike!.uid));
          await documentReference.set(newModel.toJson());
        });

        commentController.clear();
        getPostData();
        getComments(postDateTime: postDateTime);
      });
    } catch (e) {}
  }

  getComments({required String postDateTime}) async {
    commentsList.clear();
    await _firestore
        .collection('comments')
        .doc(postDateTime)
        .collection(postDateTime)
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((element) {
        var commentData = CommentModel.fromJson(element.data());
        bool alreadyExists = commentsList
            .any((comment) => comment.dateTime == commentData.dateTime);
        if (!alreadyExists) {
          commentsList.add(commentData);
          commentsList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        }
      });
    });
  }

  ScrollController scrollController = ScrollController();
  // void scrollUp() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (scrollController.hasClients) {
  //       scrollController.jumpTo(scrollController.position.minScrollExtent);
  //     }
  //   });
  // }

  ScrollController commentScrollController = ScrollController();
  // void scrollDown() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (commentScrollController.hasClients) {
  //       commentScrollController
  //           .jumpTo(scrollController.position.maxScrollExtent);
  //     }
  //   });
  // }

  RxInt _selectedPostIndex = 0.obs;
  int get selectedPostIndex => _selectedPostIndex.value;
  changeSelectedPostIndex(int index) {
    _selectedPostIndex.value = index;
  }

  Future likeDislike(
      {required String postDateTime, required bool isLike}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('Posts')
        .where('dateTime', isEqualTo: postDateTime)
        .get();

    querySnapshot.docs.forEach((doc) async {
      PostModel model = PostModel.fromJson(doc.data());
      DocumentReference<Map<String, dynamic>> documentReference = doc.reference;
      List<String> uidList = List.from(model.likeUnlike!.uid!);
      uidList.add(uid.value);
      
      List<String> uidRemovedList = List.from(model.likeUnlike!.uid!);
      uidRemovedList.removeWhere((element) => element == uid.value);
      PostModel likeModel = PostModel(
          email: model.email,
          post: model.post,
          name: model.name,
          dateTime: postDateTime,
          imageUrl: model.imageUrl,
          userImage: model.userImage,
          likeUnlike: LikeUnlike(
              like: model.likeUnlike!.like! + 1,
              unlike: model.likeUnlike!.unlike! == 0
                  ? 0
                  : model.likeUnlike!.unlike! - 1,
              comment: model.likeUnlike!.comment!,
              uid: uidList));
      PostModel unLikeModel = PostModel(
          email: model.email,
          post: model.post,
          name: model.name,
          dateTime: postDateTime,
          userImage: model.userImage,
          imageUrl: model.imageUrl,
          likeUnlike: LikeUnlike(
              like: model.likeUnlike!.like! == 0
                  ? 0
                  : model.likeUnlike!.like! - 1,
              unlike: model.likeUnlike!.unlike! + 1,
              comment: model.likeUnlike!.comment!,
              uid: uidRemovedList));
      if (isLike == true) {
        await documentReference
            .set(likeModel.toJson())
            .whenComplete(() => getPostData());
        getPostData();
      } else {
        await documentReference
            .set(unLikeModel.toJson())
            .whenComplete(() => getPostData());
      }
    });
  }
RxString _pickedProfileImage = ''.obs;
  String get pickedProfileImage => _pickedProfileImage.value;

  pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedProfileImage.value = image.path;
    }
  }

  updateProfile({
    required BuildContext context,
    required String imageData,
    required String name,
    required String email,
    required String country,
  }) async {
    showLoadingIndicator(context: context);
    String imageUrl = '';
    if (imageData != '') {
      Reference storage = FirebaseStorage.instance.ref().child(
          'profile/[profile-${DateTime.now().microsecondsSinceEpoch.toString()}');
      await storage.putFile(File(imageData));
      imageUrl = await storage.getDownloadURL();
    }

    if (imageUrl != '') {
      _firestore
          .collection('users')
          .doc(uid.value)
          .update({
            "name": name,
            "email": email,
            "country": country,
            "image": imageUrl
          })
          .whenComplete(() => _pickedProfileImage.value = '')
          .whenComplete(() => getUsersData())
          .whenComplete(() => hideOpenDialog(context: context));
    } else {
      _firestore
          .collection('users')
          .doc(uid.value)
          .update({
            "name": name,
            "email": email,
            "country": country,
          })
          .whenComplete(() => getUsersData())
          .whenComplete(() => hideOpenDialog(context: context));
    }
    
  }
  void deleteUser() async {
      try {
   final prefs = await SharedPreferences.getInstance();
                prefs.setString("email", "null");
                prefs.setString("password", "null");
                prefs.setString("uid", "null");
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                await firebaseAuth
                    .signOut()

                    .whenComplete(() => Get.offAll(const LoginScreen()));
        print('User deleted successfully.');
      } catch (e) {
        print('Failed to delete user: $e');
      }
    }
}
