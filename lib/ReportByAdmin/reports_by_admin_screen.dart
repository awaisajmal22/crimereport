import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iuvo/ReportByAdmin/controller/reports_by_admin_controller.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/pdfViewer/pdf_viewer_screen.dart';
import 'package:iuvo/view/create_report_sceen/model/report_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReportsByAdminScreen extends StatelessWidget {
  ReportsByAdminScreen({super.key});
  final controller = Get.put(ReportsByAdminController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: width * 0.04),
        child: controller.reportList.isEmpty
            ? const Center(
                child: Text("No Report Submit Yet"),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  ReportModel reportModel = controller.reportList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(-2, 2),
                            blurRadius: 7,
                            spreadRadius: 5)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          reportModel.reportTtitle ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.05,
                          ),
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: width * 0.01,
                                  horizontal: width * 0.03),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: appThemeColor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                reportModel.reportType ?? '',
                                style: const TextStyle(color: appThemeColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        Text(
                          reportModel.description ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            print("NextScreen");
                            Get.to(PDFViewerScreen(
                                pdfUrl: reportModel.fileUrl!, isNetwrok: true));
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: width,
                            child: SfPdfViewer.network(reportModel.fileUrl!),
                          ),
                        ),
                        SizedBox(
                          height: width * 0.04,
                        ),
                        reportModel.reportApproval == 0
                            ? InkWell(
                                onTap: () {
                                  controller.approveReport(
                                      dateTime: reportModel.dateTime!);
                                },
                                child: Text(
                                  "Approve",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: reportModel.reportApproval == 0
                                          ? Colors.blueAccent
                                          : Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: width * 0.04,
                  );
                },
                itemCount: controller.reportList.length),
      ),
    ));
  }
}
