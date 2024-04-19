import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iuvo/components/constant/constant.dart';
import 'package:iuvo/view/create_report_sceen/controller/create_report_controller.dart';
import 'package:iuvo/view/create_report_sceen/create_report_screen.dart';
import 'package:iuvo/view/create_report_sceen/model/report_model.dart';

class ReportStatusScreen extends StatefulWidget {
  const ReportStatusScreen({Key? key}) : super(key: key);

  @override
  State<ReportStatusScreen> createState() => _ReportStatusScreenState();
}

class _ReportStatusScreenState extends State<ReportStatusScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getReport();
  }

  final controller = Get.put(CreateReportController());
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const CreateNewReportScreen()),
        child: Icon(Icons.add),
      ),
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
                            height: width * 0.04,
                          ),
                          Text(
                            reportModel.reportApproval == 0
                                ? "Pending"
                                : "Approved",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: reportModel.reportApproval == 0
                                    ? Colors.blueAccent
                                    : Colors.green,
                                fontWeight: FontWeight.bold),
                          )
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
      ),
    );
  }

  List<ReportStatusModel> list = [
    ReportStatusModel(
        title: "Harassment in College",
        category: "Abuse",
        description:
            "Harassment done by locals on foreign tourists. Video proofs are attached to the report kindly take action ",
        status: "Pending"),
    ReportStatusModel(
        title: "Drugs Smuggling",
        category: "Drugs",
        description:
            "2 to 3 trucks have entered the city containing drugs in it. Video proofs are attached. Kindly hide my identity.",
        status: "Approved"),
    ReportStatusModel(
        title: "Bank Robbery",
        category: "Robbery",
        description:
            "3 bank robbers are identified from lasr week bank robbery. Pictures are attached. Hide my identity.",
        status: "Approve"),
  ];
}

class ReportStatusModel {
  String title;
  String description;
  String category;
  String status;
  ReportStatusModel(
      {required this.title,
      required this.category,
      required this.description,
      required this.status});
}
