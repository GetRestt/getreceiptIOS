import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/pdf/generate_pdf.dart';
import 'package:get_receipt/services/loading_indicator_dialog.dart';
import 'package:provider/provider.dart';

import '../db/items_database.dart';
import '../db/receipt_database.dart';
import '../db/withholding_database.dart';
import '../model/local/account.dart';
import '../model/main_withhold_data.dart';
import '../pdf/generate_withhold_pdf.dart';
import '../pdf/preview_pdf.dart';
import '../services/mainservice.dart';
import 'package:pdf/widgets.dart' as pw;

import '../services/withholding_service.dart';

class MainWithholdCard extends StatefulWidget {

  const MainWithholdCard({Key? key, required this.mainData,required this.userInfo }) : super(key: key);
  final MainWithholdData mainData;
  final Account userInfo;


  @override
  State<MainWithholdCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainWithholdCard> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      //margin: EdgeInsets.all(10) ,
      height: 200,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async{
              LoadingIndicatorDialog().show(context);
              MainService _mainService = Provider.of<MainService>(context, listen: false);
              await WithholdingDatabase.instance.update(widget.mainData.morNo!);
              await _mainService.localRefresh();
              LoadingIndicatorDialog().dismiss();
              //final pdfFile =
              pw.Document myDoc = await GenerateWithholdingPdf.generate(widget.mainData);
              String fileName='${Utils.formatStringNoSpace(widget.mainData.senderName!)}_invoice.pdf' ;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context)=>PreviewScreen(fileName: fileName, doc: myDoc,)),
              );
            },
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
/*                ListTile(
                    title:  Text( Utils.formatDate(mainData.date!.toDate() ),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color:Colors.green),),

                    //subtitle: Text('Dire International Hotel', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 15, ),),
                    trailing: RichText ( text:  TextSpan( children: [
                      const TextSpan(text: 'Sub Total :  ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                      TextSpan(text: mainData.total.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                    ]
                    ),
                    ),),*/
                  Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20, bottom: 5, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Document No : ${widget.mainData.morNo??""}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color:Colors.green) ,),

                          ],
                        ),
                      )
                  ) ,
                  Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20, bottom: 5, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             (widget.mainData.isNew ==1 ) ? Text('New', style: const TextStyle(backgroundColor: Colors.blue,fontWeight: FontWeight.bold, fontSize: 15, color:Colors.white),) :
                             Icon(Icons.date_range),
                            Text(Utils.formatDate(widget.mainData.createdAt!), style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color:Colors.green) ,),
                            RichText ( text:  TextSpan( children: [
                              //TextSpan(text: Utils.formatDate(widget.mainData.date!.toDate()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color:Colors.green),),
                              TextSpan(text: 'Sub Total :  ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                              TextSpan(text: widget.mainData.preTax.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                            ]
                            ),
                            ),
                          ],
                        ),
                      )
                  ) ,
                  Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20, bottom: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.mainData.senderName ?? "", style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 13, ),),
                            RichText ( text:  TextSpan( children: [
                              TextSpan(text: 'WTH Amt :  ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                              TextSpan(text: widget.mainData.withholdAmt.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                            ]
                            ),
                            ),
                          ],
                        ),
                      )
                  ) ,
                  Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20, bottom: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sender TIN : ${widget.mainData.senderTin??""}'),
                            RichText ( text:  TextSpan( children: [
                              TextSpan(text: 'Grand Total  : ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                              TextSpan(text: widget.mainData.withholdAmt.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                            ]
                            ),
                            ),
                          ],
                        ),
                      )
                  ) ,
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /* TextButton(
                          child: const Text('View'),
                          onPressed: () async {
                            //LoadingIndicatorDialog().show(context); // start dialog
                            GeneratePdf.preView(widget.mainData,widget.userInfo);
                          },
                        ),*/
                        SizedBox( width: MediaQuery.of(context).size.width*0.05,),
                        TextButton(
                          child:  const Text('View', style: TextStyle(color: Colors.blue),) ,
                          onPressed: () async{
                            LoadingIndicatorDialog().show(context);
                            WithholdingService _mainService = Provider.of<WithholdingService>(context, listen: false);
                            await WithholdingDatabase.instance.update(widget.mainData.morNo!);
                            await _mainService.localRefresh();
                            LoadingIndicatorDialog().dismiss();
                            //final pdfFile =
                            pw.Document myDoc = await GenerateWithholdingPdf.generate(widget.mainData);
                            String fileName='${Utils.formatStringNoSpace(widget.mainData.senderName!)}_invoice.pdf' ;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context)=>PreviewScreen(fileName: fileName, doc: myDoc,)),
                            );
                            //LoadingIndicatorDialog().dismiss();// end dialog
                            //PdfMain.openFile(pdfFile);
                          },
                        ),
                        SizedBox( width: MediaQuery.of(context).size.width*0.01,),
                        IconButton(onPressed: () async {
                          showDialog<bool>(
                              context: context, builder: (context)=>AlertDialog(
                            content: Text('Confirmation!', style: TextStyle(fontSize: 12),),
                            title: Text('Do you want to delete from your device?', style: TextStyle(fontSize: 14),),
                            actions: [
                              ElevatedButton(onPressed: ()=>Navigator.pop(context, false),
                                child: Text('No', style: TextStyle(color: Colors.white),),
                                style:ButtonStyle(backgroundColor:  MaterialStateProperty.all<Color>(Colors.green) ),
                              ),
                              ElevatedButton(onPressed: () async {
                                LoadingIndicatorDialog().show(context);

                                await WithholdingDatabase.instance.deleteMorNo(widget.mainData.morNo!);
                                WithholdingService _mainService = Provider.of<WithholdingService>(context, listen: false);
                                final localRefresh= _mainService.localRefresh();
                                Future
                                    .wait([localRefresh]) //initializeAccount //paidReceipt,pendingReceipt
                                    .then((value) => {
                                  LoadingIndicatorDialog().dismiss(),

                                  Utils.mainAppNav.currentState!.pushNamed('/withholding')  ,
                                });

                              },
                                child: Text('Yes', style: TextStyle(color: Colors.white),),
                                style:ButtonStyle(backgroundColor:  MaterialStateProperty.all<Color>(Colors.green) ),
                              )],
                          )
                          );
                        }, icon: Icon(Icons.delete))
                      ],
                    ),
                  )
/*                ButtonBarTheme ( // make buttons use the appropriate styles for cards
                    data: ButtonBarThemeData(),
                    child: ButtonBar(
                      children: <Widget>[
                        TextButton(
                          child: const Text('View'),
                          onPressed: () async {
                            final pdfFile = await GeneratePdf.generate(mainData);
                            PdfMain.openFile(pdfFile);
                          },
                        ),
                        TextButton(
                          child: const Text('Download'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
