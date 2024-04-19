import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/loading_dialog.dart';
import 'package:iuvo/view/create_report_sceen/model/report_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReportController extends GetxController {
  RxString filePath = ''.obs;
  RxList pickFiles = [].obs;
  pickPDFfile() async {
    if (pickFiles.isEmpty && pickFiles.length < 1) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
        ],
      );
      pickFiles.add(result!.files[0].path);
      if (pickFiles.isNotEmpty) {
        filePath.value = pickFiles[0];
      }
    }
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // User? user = FirebaseAuth.instance.currentUser;
  postReport({
    required BuildContext context,
    required String reportType,
    required String reportTtitle,
    required String reportFor,
    required String country,
    required String description,
    required String fileUrl,
  }) async {
    try {
      ReportModel reportModel = ReportModel();
      reportModel.country = country;
      reportModel.reportType = reportType;
      reportModel.description = description;
      reportModel.fileUrl = fileUrl;
      reportModel.reportTtitle = reportTtitle;
      reportModel.reportFor = reportFor;
      reportModel.reportApproval = 0;
      reportModel.uid = uid.value;
      reportModel.dateTime = DateTime.now().toIso8601String();
      await _firestore
          .collection('reports')
          .doc()
          .set(reportModel.toJson())
          .whenComplete(() {
            hideOpenDialog(context: context);
          })
          .whenComplete(() => Get.back())
          .whenComplete(() => getReport());
    } catch (e) {}
  }

  RxList<ReportModel> reportList = <ReportModel>[].obs;
  getReport() async {
    reportList.clear();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection("reports")
        .where('uid', isEqualTo: uid.value)
        .get();
    querySnapshot.docs.forEach((doc) {
      var reportData = ReportModel.fromJson(doc.data());
      bool alreadyExists =
          reportList.any((report) => report.dateTime == reportData.dateTime);
      if (!alreadyExists) {
        reportList.add(reportData);
        print(reportList.length);
        reportList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      }
    });
  }

  uploadFile({
    required BuildContext context,
    required String reportType,
    required String reportTtitle,
    required String reportFor,
    required String country,
    required String description,
    required String fileUrl,
  }) async {
    try {
      showLoadingIndicator(context: context);
      if (fileUrl != '') {
        Reference storage = FirebaseStorage.instance.ref().child(
            'reports/[report-${DateTime.now().microsecondsSinceEpoch.toString()}');
        await storage.putFile(File(fileUrl));
        await storage.getDownloadURL().then((value) {
          postReport(
              context: context,
              reportType: reportType,
              reportTtitle: reportTtitle,
              reportFor: reportFor,
              country: country,
              description: description,
              fileUrl: value);
        });
      } else {
        postReport(
            context: context,
            reportType: reportType,
            reportTtitle: reportTtitle,
            reportFor: reportFor,
            country: country,
            description: description,
            fileUrl: fileUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went Wrong..')));
    }
  }
  RxString uid = ''.obs;
getUid() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
uid.value =pref.getString('uid') ?? '';
if(uid.value != ''){
   getReport();
}
}
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getReport();
  }
}
