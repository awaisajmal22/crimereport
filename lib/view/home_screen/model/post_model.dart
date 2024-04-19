
import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
    String? post;
    String? name;
    String? dateTime;
    String? imageUrl;
    String? userImage;
    String? email;
    LikeUnlike? likeUnlike;

    PostModel({
        this.post,
        this.name,
        this.imageUrl,
        this.dateTime,
        this.likeUnlike,
        this.email,
        this.userImage,
    });

    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        post: json["post"],
        name: json["name"],
        userImage: json['userImage'],
        dateTime: json["dateTime"],
        imageUrl: json["imageUrl"],
        email: json["email"],
        likeUnlike: json["likeUnlike"] == null ? null : LikeUnlike.fromJson(json["likeUnlike"]),
    );

    Map<String, dynamic> toJson() => {
        "post": post,
        "name": name,
        "dateTime":dateTime,
        "userImage":userImage,
        "imageUrl": imageUrl,
        "email": email,
         "likeUnlike": likeUnlike?.toJson(),
    };
}


class LikeUnlike {
    int? unlike;
    int? like;
    int? comment;
    List<String>? uid;

    LikeUnlike({
        this.unlike,
        this.like,
        this.comment,
        this.uid,
    });

    factory LikeUnlike.fromJson(Map<String, dynamic> json) => LikeUnlike(
        unlike: json["unlike"],
        comment: json['comment'],
        like: json["like"],
           uid: json["uid"] == null ? [] : List<String>.from(json["uid"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "unlike": unlike,
        "like": like,
        "comment":comment,
        "uid": uid == null ? [] : List<String>.from(uid!.map((x) => x)),
    };
}
