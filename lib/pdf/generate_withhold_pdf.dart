import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_receipt/model/local/account.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../helpers/utils.dart';
import '../model/main_withhold_data.dart';

class GenerateWithholdingPdf {

  static Future<pw.Document> bulkGenerate(List<MainWithholdData> invoiceList) async {
    final bulkPdf = pw.Document();
    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/NotoSansEthiopic-Regular.ttf'),
    );
    for (var invoice in invoiceList) {
      bulkPdf.addPage(
        pw.MultiPage(
          build: (context) => [
            buildHeader(invoice),
            pw.SizedBox(height: 2 * PdfPageFormat.cm),
            buildTitle(invoice, font),
            buildInvoice(invoice),
            pw.Divider(),
            buildTotal(invoice),
          ],
          footer: (context) => buildFooter(invoice),
        ),
      );
    }

    return bulkPdf;
  }

  static Future<pw.Document> generate(MainWithholdData invoice) async {
    final pdf = pw.Document();
    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/NotoSansEthiopic-Regular.ttf'),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          buildHeader(invoice),
          pw.SizedBox(height: 2 * PdfPageFormat.cm),
          buildTitle(invoice, font),
          buildInvoice(invoice),
          pw.Divider(),
          buildTotal(invoice),
        ],
        footer: (context) => buildFooter(invoice),
      ),
    );

    return pdf;
  }

  /// HEADER
  ///
  static pw.Widget buildHeader(MainWithholdData invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        /// 🔝 TOP (Centered)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("POS System"),
            pw.Text(
              invoice.senderName ?? "",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "${invoice.senderCity ?? 'N/A'} - (${invoice.senderAddress ?? 'N/A'})",
            ),
          ],
        ),

        pw.SizedBox(height: 10),

        /// 🔽 BOTTOM ROW (Left + Right)
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// LEFT (you can add logo or keep empty)
            pw.Text(""), // placeholder (or logo)

            /// RIGHT (Meta info)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  "Invoice No: ${invoice.morNo}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("RRN: ${invoice.rrn}"),
                pw.Text("System No: ${invoice.systemNo}"),
                pw.Text(
                  "Date-Time: ${invoice.createdAt != null
                      ? "${invoice.createdAt!.day.toString().padLeft(2,'0')}/"
                      "${invoice.createdAt!.month.toString().padLeft(2,'0')}/"
                      "${invoice.createdAt!.year} "
                      "${invoice.createdAt!.hour.toString().padLeft(2,'0')}:"
                      "${invoice.createdAt!.minute.toString().padLeft(2,'0')}"
                      : 'N/A'}",
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  /// TITLE
  static pw.Widget buildTitle(MainWithholdData invoice, font) => pw.Container(
    width: double.infinity,
    color: PdfColors.grey300,
    padding: const pw.EdgeInsets.all(6),
    child: pw.Column(
      children: [
        pw.Text(invoice.title ?? "Withholding Tax on Payment",
            style: pw.TextStyle(font: font,fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );

  /// INVOICE TABLE
  static pw.Widget buildInvoice(MainWithholdData invoice) => pw.Column(
    children: [
      pw.SizedBox(height: 10),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 7,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("From: ${invoice.senderName ?? 'N/A'}"),
                pw.Text("City: ${invoice.senderCity ?? 'N/A'}"),
                pw.Text("Wereda: ${invoice.senderWereda ?? 'N/A'}"),
                pw.Text("TIN: ${invoice.senderTin ?? 'N/A'}"),
                pw.Text("VAT: ${invoice.senderVat ?? 'N/A'}"),
              ],
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Image(pw.MemoryImage(base64Decode(invoice.qr)), height: 100),
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("To: ${invoice.receiverName ?? ''}"),
                pw.Text("City: ${invoice.receiverCity ?? 'N/A'}"),
                pw.Text("Phone: ${invoice.receiverPhoneNo ?? ''}"),
                pw.Text("TIN: ${invoice.receiverTin ?? 'N/A'}"),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Table.fromTextArray(
        headers: ["S.N", "IRN", "Pre Tax Amount", "Withhold"],
        data: [
          [
            "1",
            invoice.irn ?? '',
            invoice.preTax.toStringAsFixed(2),
            invoice.withholdAmt.toStringAsFixed(2),
          ]
        ],
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
        },
      ),
    ],
  );

  static pw.Widget buildTotal(MainWithholdData invoice) {
    final preTax = invoice.preTax?.toDouble() ?? 0;
    final totalWithhold = invoice.withholdAmt?.toDouble() ?? 0;

    pw.Widget row(String title, String value, {bool bold = false}) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title),
          pw.Text(
            value,
            style:
            bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
          ),
        ],
      );
    }

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 220,
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          color: PdfColors.grey100,
        ),
        child: pw.Column(
          children: [
            row("PreTax", Utils.formatPrice(preTax)),
            row("Total Withhold", Utils.formatPrice(totalWithhold),
                bold: true),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  /// FOOTER
  static pw.Widget buildFooter(MainWithholdData invoice) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(height: 10),
      pw.Text("In Words: ${invoice.words ?? ''}"),
      pw.SizedBox(height: 10),
      pw.Text("Receiver Name & Signature: ${invoice.receiverName ?? ''}"),
      pw.SizedBox(height: 10),
      pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(6),
        child: pw.Column(
          children: [
            pw.Text("MOR"),
            pw.Text(
              "Power By Get Rest Technology Service and Trading PLC",
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    ],
  );
}