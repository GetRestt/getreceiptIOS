import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

import '../model/local/account.dart';

class GenerateReceiptPdf {
  static Future<pw.Document> generateDynamic(
      MainData invoice, Account userInfo) async {
    final pdf = pw.Document();
    final isReceipt = (invoice.qrReceipt != null && invoice.qrReceipt != "");

    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/NotoSansEthiopic-Regular.ttf'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          buildHeader(invoice, userInfo, isReceipt),
          pw.SizedBox(height: 15),
          buildBuyer(invoice),
          pw.SizedBox(height: 15),
          buildTitle(invoice, isReceipt, font),
          pw.SizedBox(height: 10),
          buildMeta(invoice, isReceipt),
          pw.SizedBox(height: 15),
          buildItemsTable(invoice),
          pw.SizedBox(height: 15),
          buildTotals(invoice),
        ],
        footer: (context) => buildFooter(invoice, isReceipt),
      ),
    );

    return pdf;
  }

  // ================= HEADER =================
  static pw.Widget buildHeader(
      MainData invoice, Account userInfo, bool isReceipt) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "From: ${invoice.senderName ?? ""}",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text("Address: ${invoice.senderAddress ?? ""}"),
              pw.Text("City: ${invoice.senderCity ?? "" }"),
              pw.Text("Phone: ${invoice.senderContactNo ?? "" }"),
              pw.Text(
                  "TIN: ${invoice.senderTinNo ?? ''}"),
              pw.Text(
                  "VAT: ${invoice.senderVatNo ??  ''}"),

            ],
          ),

          pw.Container(
            padding: const pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: isReceipt && invoice.qrReceipt != null
                ? pw.Image(
              pw.MemoryImage(base64Decode(invoice.qrReceipt!)),
              width: 90,
              height: 90,
            )
                : pw.Image(
              pw.MemoryImage(base64Decode(invoice.qr!)),
              width: 90,
              height: 90,
            ),
          ),

        ],
      ),

    );
  }
  static pw.Widget  buildBuyer(MainData invoice) => pw.Column(
      children: [ pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("To: ${invoice.buyerName ?? ''}"),
          pw.Text("Phone: ${invoice.userPhoneNo ?? ''}"),
          pw.Text("TIN: ${invoice.buyerTinNo ?? 'N/A'}"),
        ],
      ),
     ]
  );
  // ================= TITLE =================
  static pw.Widget buildTitle(MainData invoice, bool isReceipt, font) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text(
        isReceipt
            ? (invoice.receiptLable ?? "RECEIPT")
            : (invoice.invoiceLable ?? "INVOICE"),
        style: pw.TextStyle(
          font: font,
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 2,

        ),
      ),
    );
  }

  // ================= META =================
  static pw.Widget buildMeta(MainData invoice, bool isReceipt) {
    pw.Widget block(List<String> lines) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: lines
              .map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(e),
          ))
              .toList(),
        ),
      );
    }

    return pw.Row(
      children: [
        pw.Expanded(
          child: block([
            "Sales Type: ${invoice.salesType ?? "N/A"}",
            if (invoice.irn != null) "IRN: ${invoice.irn}",
            if (invoice.systemNumber != null)
              "System No: ${invoice.systemNumber}",
            if (!isReceipt && invoice.type != null)
              "Type: ${invoice.type}",
          ]),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: block([
            "Date: ${Utils.formatDate(invoice.date!)}",
            "Doc No: ${invoice.documentNo ?? 'N/A'}",
            if (invoice.referenceIrn != null)
              "Ref IRN: ${invoice.referenceIrn}",
          ]),
        ),
      ],
    );
  }

  // ================= TABLE =================
  static pw.Widget buildItemsTable(MainData invoice) {
    final headers = [
      'S.N',
      'Name',
      'UoM',
      'Qty',
      'Unit Price',
      'Tax',
      'Tax Amt',
      'Disc',
      'Total'
    ];

    final data = invoice.items!.asMap().entries.map((entry) {
      final i = entry.key + 1;
      final item = entry.value;
      final total =
          (item.unitPrice ?? 0) * (item.quantity?.toDouble() ?? 0);

      return [
        '$i',
        item.productDescription ?? item.itemCode ?? '',
        item.unit ?? '',
        item.quantity?.toString() ?? '0',
        item.unitPrice?.toStringAsFixed(2) ?? '0.00',
        item.taxCode ?? '',
        item.taxAmount?.toStringAsFixed(2) ?? '0.00',
        item.discount?.toStringAsFixed(2) ?? '0.00',
        total.toStringAsFixed(2),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration:
      pw.BoxDecoration(color: PdfColors.blueGrey800),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey200)),
      ),
      cellPadding: const pw.EdgeInsets.all(6),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
      },
    );
  }

  // ================= TOTALS =================
  static pw.Widget buildTotals(MainData invoice) {
    final subTotal = invoice.total?.toDouble() ?? 0;
    final discount = invoice.discount?.toDouble() ?? 0;
    final serviceCharge = invoice.scAmt?.toDouble() ?? 0;
    final vat = invoice.tax?.toDouble() ?? 0;
    final grandTotal = invoice.grandTotal?.toDouble() ?? 0;

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
            row("Net Total", Utils.formatPrice(subTotal)),
            if (discount > 0)
              row("Discount", Utils.formatPrice(discount)),
            if (serviceCharge > 0)
              row("Service Charge",
                  Utils.formatPrice(serviceCharge)),
            row("VAT (15%)", Utils.formatPrice(vat)),
            pw.Divider(),
            row("Grand Total", Utils.formatPrice(grandTotal),
                bold: true),
            pw.SizedBox(height: 5),
            pw.Text(
              invoice.amountInWords ?? '',
              style: pw.TextStyle(
                  fontSize: 9,
                  fontStyle: pw.FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FOOTER =================
  static pw.Widget buildFooter(MainData invoice, bool isReceipt) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 5),

        isReceipt
        ? pw.Text("Payment: ${invoice.receiptPayment ?? 'N/A'}")
            : pw.Text("Payment: ${invoice.paymentMode ?? 'Credit'}"),

        pw.Text(
            "Customer: ${invoice.buyerName ?? 'Walking Customer'}"),
        if (invoice.referenceIrn != null)
          pw.Text("Ref IRN: ${invoice.referenceIrn}"),
        pw.SizedBox(height: 5),
        pw.Text(
          "Powered by Get Rest Technology",
        ),
      ],
    );
  }
}