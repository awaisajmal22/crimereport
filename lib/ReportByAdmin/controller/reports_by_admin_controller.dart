import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iuvo/view/create_report_sceen/model/report_model.dart';

class ReportsByAdminController extends GetxController {
  RxList<ReportModel> reportList = <ReportModel>[].obs;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getReport() async {
    reportList.clear();
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection("reports").get();
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

  Future approveReport({
    required String dateTime,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .where("dateTime", isEqualTo: dateTime)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({
            'reportApproval': 1,
          }).whenComplete(() => getReport());
          print('Report approved successfully!');
        });
      } else {
        print('No report found with the given dateTime.');
      }
    } catch (e) {
      print('Error approving report: $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getReport();
  }
}
