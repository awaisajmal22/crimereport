import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/chat_room_screen/chat_room_screen.dart';
import 'package:iuvo/view/smart_chat_screen/smart_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.to(const SmartChatScreen()),
          icon: Image.asset(
            Assets.imageGpt,
            scale: 15,
          ),
          label: Text("Talk with Us"),
        ),
        body: Center(
          child: Text('Lets Chat with Us'),
        )
        // ListView.separated(
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         onTap: () => Get.to(const ChatRoomScreen()),
        //         leading: CircleAvatar(
        //           child: Image.asset(Assets.imageAvater),
        //         ),
        //         title: Text(list[index].title),
        //         subtitle: Text(list[index].subtitle),
        //         trailing: Column(
        //           children: [
        //             CircleAvatar(
        //               radius: width * 0.03,
        //               backgroundColor: list[index].messageCount == "0"
        //                   ? Colors.white
        //                   : appThemeColor.withOpacity(0.8),
        //               child: Text(
        //                 list[index].messageCount,
        //                 style: TextStyle(
        //                     fontSize: width * 0.03, color: Colors.white),
        //               ),
        //             ),
        //             SizedBox(
        //               height: width * 0.02,
        //             ),
        //             Text(
        //               list[index].time,
        //               style: TextStyle(color: Colors.grey.withOpacity(0.5)),
        //             )
        //           ],
        //         ),
        //       );
        //     },
        //     separatorBuilder: (context, index) {
        //       return const Divider();
        //     },
        //     itemCount: 0),
        );
  }

  List<ChatScreenModel> list = [
    ChatScreenModel(
        title: 'Anonymous User',
        subtitle: "I am with you",
        time: "11:00 PM",
        messageCount: "2"),
    ChatScreenModel(
        title: 'John Doe',
        subtitle: "You are doing great!!",
        time: "11:59 PM",
        messageCount: "1"),
    ChatScreenModel(
        title: 'James White',
        subtitle: "Say No to Violence",
        time: "03:44 PM",
        messageCount: "3"),
    ChatScreenModel(
        title: 'Anonymous@User11',
        subtitle: "Hey! How may I help you",
        time: "12:11 PM",
        messageCount: "1"),
    ChatScreenModel(
        title: 'Anonymous User',
        subtitle: "I need some help",
        time: "9:00 PM",
        messageCount: "9"),
    ChatScreenModel(
        title: 'Ayesha ahmed',
        subtitle: "Let's find out the solution!",
        time: "2:09 PM",
        messageCount: "5"),
    ChatScreenModel(
        title: 'Arsalan Khan ',
        subtitle: "Assalam o alaikum",
        time: "07:24 PM",
        messageCount: "1"),
    ChatScreenModel(
        title: 'Unknown202',
        subtitle: "Hey there!",
        time: "1:11 PM",
        messageCount: "1"),
  ];
}

class ChatScreenModel {
  String title;
  String subtitle;
  String time;
  String messageCount;
  ChatScreenModel(
      {required this.title,
      required this.subtitle,
      required this.time,
      required this.messageCount});
}
