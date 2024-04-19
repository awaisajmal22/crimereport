import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/home_screen/controller/home_controller.dart';

class ChatGptMessageTile extends StatelessWidget {
  ChatGptMessageTile({
    Key? key,
    required this.isMe,
    required this.width,
    required this.message,
    required this.time,
  }) : super(key: key);

  final bool isMe;
  final double width;
  final String message;
  final String time;
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMe
            ? Container()
            : CircleAvatar(
                child: Image.asset(
                  Assets.imageGpt,
                  scale: 20,
                ),
              ),
        SizedBox(
          width: width * 0.04,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: width * 0.04, horizontal: width * 0.04),
          width: width * 0.7,
          decoration: BoxDecoration(
            color: isMe ? appThemeColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(-2, 2),
                  blurRadius: 7,
                  spreadRadius: 5),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: width * 0.03,
              ),
              // Text(time,textAlign: TextAlign.right,style: TextStyle(color:isMe ?Colors.white:Colors.grey),),
            ],
          ),
        ),
        SizedBox(
          width: width * 0.04,
        ),
        isMe
            ? Obx(
                () => CircleAvatar(
                    backgroundImage:
                        NetworkImage(controller.userModel.value.image!)),
              )
            : Container(),
      ],
    );
  }
}
