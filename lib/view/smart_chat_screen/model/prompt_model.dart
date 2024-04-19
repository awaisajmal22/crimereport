import 'dart:convert';

PromptModel promptModelFromJson(String str) => PromptModel.fromJson(json.decode(str));

String promptModelToJson(PromptModel data) => json.encode(data.toJson());

class PromptModel {
    String role;
    String content;
    

    PromptModel({
        required this.role,
        required this.content,
    });

    factory PromptModel.fromJson(Map<String, dynamic> json) => PromptModel(
        role: json["role"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
    };
}