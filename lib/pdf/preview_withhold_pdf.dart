
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:get_receipt/pdf/preview_pdf.dart';
import '../model/main_withhold_data.dart';
import 'generate_withhold_pdf.dart'; // your existing PreviewScreen

class WithholdingPreviewPage extends StatelessWidget {
  final MainWithholdData invoice;
  const WithholdingPreviewPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<pw.Document>(
      future: GenerateWithholdingPdf.generate(invoice),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Preview")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Preview")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // Document is ready, show preview
        return PreviewScreen(
          doc: snapshot.data!,
          fileName: "${invoice.morNo}_withholding_receipt.pdf",
        );
      },
    );
  }
}