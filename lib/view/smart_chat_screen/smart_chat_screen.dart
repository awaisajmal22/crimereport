import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/components/widget/chat_textfield.dart';
import 'package:iuvo/components/widget/messageTitleSorChatGpt.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/smart_chat_screen/controller/smart_chat_controller.dart';

class SmartChatScreen extends StatefulWidget {
  const SmartChatScreen({Key? key}) : super(key: key);

  @override
  State<SmartChatScreen> createState() => _SmartChatScreenState();
}

class _SmartChatScreenState extends State<SmartChatScreen> {
  TextEditingController controller = TextEditingController();
  String message =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ";
  String time = "10:00 PM";
  bool isMe = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm.sendMessage('Hi');
  }

  final vm = Get.put(SmartChatController());
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              child: Image.asset(Assets.imageGpt),
            ),
            SizedBox(
              width: width * 0.04,
            ),
            const Text("Chat Bot")
          ],
        ),
      ),
      bottomSheet: Container(
        height: width * 0.2,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.020),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // CircleAvatar(
            //   backgroundColor: appThemeColor,
            //   child: Icon(
            //     Icons.more_horiz_outlined,
            //     color: Colors.white,
            //   ),
            // ),
            Expanded(
                // width: width * 0.6,
                child: ChatTextField(
                    controller: controller,
                    maxline: 1,
                    hintText: "Type....",
                    width: width)),
            SizedBox(
              width: width * 0.020,
            ),
            InkWell(
              onTap: () {
                vm.sendMessage(controller.text);
                controller.clear();
              },
              child: CircleAvatar(
                backgroundColor: appThemeColor,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => Container(
            padding: EdgeInsets.symmetric(
                vertical: width * 0.04, horizontal: width * 0.04),
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: width * 0.2,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? SizedBox.shrink()
                      : ChatGptMessageTile(
                          isMe: vm.messagesList![index].role == "user"
                              ? true
                              : false,
                          width: width,
                          message: vm.messagesList![index].content,
                          time: DateTime.now().toIso8601String());
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: width * 0.04,
                  );
                },
                itemCount: vm.messagesList!.length)),
      ),
    );
  }

  List<Message> list = [
    Message(
        message:
            "Hey there! I am your friendly, helping chatbot. What would you like to know!?",
        time: "12:00 PM",
        isMe: false),
  ];
}

class Message {
  String message;
  String time;
  bool isMe;
  Message({required this.message, required this.time, required this.isMe});
}
