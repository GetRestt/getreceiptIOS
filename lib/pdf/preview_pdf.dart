import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../helpers/utils.dart';

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;
  final String fileName;
  const PreviewScreen({Key? key, required this.doc, required this.fileName }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async {
        Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          return true;
          //Navigator.of(context).pop();
          //return Future.value(true);
        }else{
          SystemNavigator.pop();
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: ()=> Utils.mainAppNav.currentState!.pushNamed('/welcomepage'),
            icon: Icon(Icons.arrow_back_outlined),
          ),
          centerTitle: true,
          title: Text("Preview"),
        ),
        body: PdfPreview(
        build: ((format) => doc.save()),
          allowSharing: true,
          allowPrinting: true,
          initialPageFormat: PdfPageFormat.a4,
          pdfFileName: fileName,
        ),
      ),
    );
  }
}
