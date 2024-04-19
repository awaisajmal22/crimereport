import 'dart:convert';

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
    String? reportType;
    String? reportTtitle;
    String? fileUrl;
    String? description;
    String? reportFor;
    String? country;
    String? uid;
    int? reportApproval;
    String? dateTime;

    ReportModel({
        this.reportType,
        this.reportTtitle,
        this.fileUrl,
        this.description,
        this.reportFor,
        this.country,
        this.reportApproval,
        this.uid,
        this.dateTime,
    });

    factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
      uid: json["uid"],
        reportType: json["reportType"],
        reportTtitle: json["reportTtitle"],
        fileUrl: json["fileUrl"],
        description: json["description"],
        reportFor: json["reportFor"],
        country: json["country"],
        reportApproval: json["reportApproval"],
        dateTime: json["dateTime"],

    );

    Map<String, dynamic> toJson() => {
      "uid":uid,
        "reportType": reportType,
        "reportTtitle": reportTtitle,
        "fileUrl": fileUrl,
        "description": description,
        "reportFor": reportFor,
        "country": country,
        "dateTime":dateTime,
        "reportApproval":reportApproval
    };
}