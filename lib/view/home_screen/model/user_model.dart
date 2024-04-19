import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? name;
    String? email;
    String? image;
    String? country;

    UserModel({
        this.name,
        this.email,
        this.image,
        this.country,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        image: json["image"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "image": image,
        "country": country,
    };
}