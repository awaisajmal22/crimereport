import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    String? comment;
    String? name;
    String? imageUrl;
    String? dateTime;

    CommentModel({
        this.comment,
        this.name,
        this.imageUrl,
        this.dateTime,
    });

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        comment: json["comment"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        dateTime:json["dateTime"],
    );

    Map<String, dynamic> toJson() => {
        "comment": comment,
        "name": name,
        "imageUrl": imageUrl,
        "dateTime":dateTime
    };
}
