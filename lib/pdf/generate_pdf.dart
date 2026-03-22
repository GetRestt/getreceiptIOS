

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../model/local/account.dart';

class GeneratePdf {

  static Future<pw.Document> bulkGenerate(List<MainData> invoiceList, Account userInfo) async{
    final bulkPdf= Document();
    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/NotoSansEthiopic-Regular.ttf'),
    );
    for (var invoice in invoiceList) {
      final isReceipt = invoice.qrReceipt != null && invoice.qrReceipt != "";
      bulkPdf.addPage(MultiPage(
        build: (context) => [
          buildHeader(invoice, userInfo, isReceipt),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildTitle(invoice, isReceipt, font),
          buildInvoice(invoice),
          Divider(),
          buildTotal(invoice),
        ],
        footer: (context) => buildFooter(invoice),
      ));
    }
    return bulkPdf;
    //return PreviewScreen(doc: bulkPdf, fileName: '${formattedDate}_bulk_invoice.pdf');
    //return PdfMain.saveDocument(name: '${formattedDate}_bulk_invoice.pdf', pdf: bulkPdf);
  }
  static Future<pw.Document> generate(MainData invoice,Account userInfo) async {
    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/NotoSansEthiopic-Regular.ttf'),
    );
    final isReceipt = invoice.qrReceipt != null && invoice.qrReceipt != "";
    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, userInfo, isReceipt),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice, isReceipt, font),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));
    return pdf;
    //return PdfRedirect(doc: pdf, fileName: '${Utils.formatStringNoSpace(invoice.senderName!)}_invoice.pdf');
    //return PdfMain.saveDocument(name: '${Utils.formatStringNoSpace(invoice.senderName!)}_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(MainData invoice,Account userInfo , isReceipt) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSupplierAddress(invoice),
          Container(
            height: 50,
            width: 50,
            child: isReceipt
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
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomerAddress(invoice, userInfo),
          buildInvoiceInfo(invoice),
        ],
      ),
    ],
  );

  static Widget buildCustomerAddress(MainData invoice, Account userInfo) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("To: ${userInfo.orgName.toString()}", style: TextStyle(fontWeight: FontWeight.bold)),
      Text("Phone: ${invoice.userPhoneNo ?? ""}", style: TextStyle(fontWeight: FontWeight.bold)),
      Text('Receiver TinNo', style: TextStyle(fontWeight: FontWeight.bold)),
      Text(invoice.buyerTinNo ?? "" , style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  static Widget buildInvoiceInfo(MainData invoice) {
    //final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
/*      'Payment Terms:',
      'Due Date:'*/
    ];
    final data = <String>[
      invoice.billNo??"",
      Utils.formatDate(invoice.date!),
      //paymentTerms,
      //Utils.formatDate(invoice.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(MainData invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Sender Name: ${invoice.senderName ?? ""}', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text('Sender Address: ${invoice.senderAddress ?? ""}'),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text("Phone: ${invoice.senderContactNo ?? ""}"),
      Text("City: ${invoice.senderCity ?? "" }"),
      Text('Sender TinNo: ${invoice.senderTinNo ?? ""}'),
      Text(
          "VAT: ${invoice.senderVatNo ??  ''}"),
    ],
  );

  static Widget buildTitle(MainData invoice,bool isReceipt,font) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
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
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      Text("Power by Get Rest Technology"),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildInvoice(MainData invoice) {
    final headers = [
      'S.N',
      'Name',
      'UoM',
      'Qty',
      'Unit Price',
      'Tax Code',
      'Tax Amount',
      'Discount',
      'Total',
    ];

    final data = invoice.items!.asMap().entries.map((entry) {
      final index = entry.key + 1; // serial number
      final item = entry.value;

      final total = (item.unitPrice ?? 0) * (item.quantity?.toDouble() ?? 0);

      return [
        '$index',
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

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.center,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(MainData invoice) {
/*    final netTotal = invoice.items
        !.map((item) => item.unitPrice! * item.qty!.toDouble())
        .reduce((item1, item2) => item1 + item2);*/
    const vatPercent = 15;
    //final vat = netTotal * 0.15;
    //final total = netTotal + vat;
    final subTotal = invoice.total!.toDouble();
    final serviceCharge = invoice.scAmt!.toDouble();
    final vat = invoice.tax!.toDouble();
    final grandTotal = invoice.grandTotal!.toDouble();
    final diff = subTotal-(grandTotal- (vat + serviceCharge));

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(subTotal),
                  unite: true,
                ),
                if(diff >0.9) ...[
                    buildText(
                    title: 'Discount Amt',
                    value: Utils.formatPrice(diff),
                    unite: true,
                  )
                ]else if(diff < -0.9)...[
                  buildText(
                    title: 'Additional fee',
                    value: Utils.formatPrice(-1 * diff),
                    unite: true,
                  )
                ],
                serviceCharge > 0?
                buildText(
                  title: 'Service Charge',
                  value: Utils.formatPrice(serviceCharge),
                  unite: true,
                ):Container(),
                buildText(
                  title: 'Vat $vatPercent %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount ',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(grandTotal),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(MainData invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Address', value: invoice.senderAddress??""),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'MOR', value: 'ET'),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Thank', value: 'You!'),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}