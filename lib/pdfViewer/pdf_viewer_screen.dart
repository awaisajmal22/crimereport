import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  bool isNetwrok;
  String pdfUrl;
  PDFViewerScreen({super.key ,this.isNetwrok = false,required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: isNetwrok == false ? SfPdfViewer.file(
        File(pdfUrl)): SfPdfViewer.network(pdfUrl)),
    );
  }
}