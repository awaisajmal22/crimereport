import 'package:flutter/material.dart';
import 'package:iuvo/generated/assets.dart';
import 'package:iuvo/view/home_screen/controller/home_controller.dart';
import 'package:iuvo/view/home_screen/model/comment_model.dart';

commentBottomSheet(
    {required BuildContext context, required HomeController controller}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03, vertical: size.height * 0.020),
    width: size.width,
    height: size.height * 0.5,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              controller.showBottomSheet(false);
            },
            child: Icon(
              Icons.close,
              size: size.height * 0.040,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Expanded(
            child: controller.commentsList.isEmpty
                ? const Center(
                    child: Text("No Comment Yet"),
                  )
                : ListView.builder(
                  controller: controller.commentScrollController,
                    itemCount: controller.commentsList.length,
                    itemBuilder: (context, index) {
                      CommentModel comment = controller.commentsList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.040,
                              width: size.width * 0.080,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(comment.imageUrl!),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: size.width * 0.020,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.name!),
                                  Text(comment.comment!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.commentController,
                decoration: InputDecoration(hintText: "Comment here.."),
              ),
            ),
            SizedBox(
              width: size.width * 0.020,
            ),
            InkWell(
              onTap: () {
                controller.postComment(
                    postDateTime: controller
                        .postsList[controller.selectedPostIndex].dateTime!,
                    imageUrl: controller.userModel.value.image?? '',
                    comment: controller.commentController.text,
                    name: controller.userModel.value.name!);
              },
              child: Icon(Icons.send),
            )
          ],
        )
      ],
    ),
  );
}
