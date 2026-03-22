import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/pdf/generate_pdf.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:get_receipt/widgets/AppBarRef.dart';
import 'package:get_receipt/widgets/FooterRef.dart';
import 'package:get_receipt/widgets/main_card.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../model/local/account.dart';
import '../model/main_withhold_data.dart';
import '../pdf/generate_withhold_pdf.dart';
import '../pdf/preview_pdf.dart';
import '../services/withholding_service.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
   DateTime _fromDate = DateTime.now().toUtc();
   DateTime _toDate = DateTime.now().toUtc();

  late List<MainData> data;
  late List<MainWithholdData> dataWithold;
  late Account _userInfo;
  late List<MainData> _filterData;
  late List<MainWithholdData> _filterDataWithold;
  final TextEditingController _companyName =  TextEditingController();
   final TextEditingController _textFromDate=  TextEditingController();
   final TextEditingController _textFromTo=  TextEditingController();
   @override
  void initState() {
    setState(() {
      MainService _receiptList = Provider.of<MainService>(context, listen: false);
      WithholdingService _witholdList = Provider.of<WithholdingService>(context, listen: false);
      data=_filterData =_receiptList.getMainData(context);
      dataWithold=_filterDataWithold =_witholdList.getMainWithholdData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoService _userInfoService = Provider.of<UserInfoService>(context, listen: false);
    _userInfo = _userInfoService.getUserInfo();

    return Scaffold(
      appBar: AppBarRef(),

      body: Column(
        children: [
          Flexible(
              flex: 15,
              child: Container(
                color: Colors.green.withOpacity(0.8),
                padding: EdgeInsets.only(left: 5, right: 5, top: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('History', style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),)
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Row(

                              children: [
                                Text('Bulk View', style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white),),
                                SizedBox(width: 5,),
                                Icon(Icons.download_outlined,
                                  color: Colors.white70, size: 28,),
                              ],
                            ),
                            onPressed: () async {
                              //final bulkPdfFile =
                              pw.Document bulkDoc =await GeneratePdf.bulkGenerate(_filterData,_userInfo);
                              DateTime now = DateTime.now();
                              String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context)=>PreviewScreen(fileName: formattedDate, doc: bulkDoc,)),
                              );
                              //LoadingIndicatorDialog().dismiss();// end dialog
                              //PdfMain.openFile(bulkPdfFile);
                            },

                          ),
                          TextButton(
                            child: Row(

                              children: [
                                Text('Bulk Withold View', style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white),),
                                SizedBox(width: 5,),
                                Icon(Icons.download_outlined,
                                  color: Colors.white70, size: 28,),
                              ],
                            ),
                            onPressed: () async {
                              //final bulkPdfFile =
                              pw.Document bulkDoc =await GenerateWithholdingPdf.bulkGenerate(_filterDataWithold);
                              DateTime now = DateTime.now();
                              String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context)=>PreviewScreen(fileName: formattedDate, doc: bulkDoc,)),
                              );
                              //LoadingIndicatorDialog().dismiss();// end dialog
                              //PdfMain.openFile(bulkPdfFile);
                            },

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ),

          Flexible(
            flex: 75,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                historyFilterCard(context),

                Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: _filterData.length,
                        itemBuilder: (BuildContext ctx, int index){
                          return MainCard(
                            status: "paid",
                            mainData: _filterData[index],
                            userInfo: _userInfo,
                          );
                        }
                    ),
                ),

              ],
            ),
          ),
          FooterRef(),
        ],
      ),
    );
  }

  Card historyFilterCard(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10),
        child: ExpandablePanel(
            header:
            Text('Filter By', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green),),
            collapsed: Text(''),
            expanded: Container(
              margin: EdgeInsets.all(5),
              child: Column(children: [
                dateFilter(context,_textFromDate, _textFromTo),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.only(top: 15),
                  child: textFilter(),
                ),
              ],),
            )
        ),
      ),
    );
  }

  Row textFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 5,
            child: TextFormField(
              controller: _companyName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  labelText: "Company Name",
              ),
              validator: (value){
                if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$' ).hasMatch(value)){
                  return "Enter correct name";
                }else{
                  return null;
                }
              },
            ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.08,),
        Flexible(
            flex: 5,
            child:  Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  IconButton(onPressed: (){
/*                    setState(() {

                    });*/
                    _filterDataList(_companyName.text, _fromDate,_toDate);
                    FocusScope.of(context).unfocus();
                  },
                    icon: Icon(Icons.search_rounded),),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                  IconButton(onPressed: (){
                    setState(() {
                      _filterData= data;
                      _filterDataWithold= dataWithold;
                      _companyName.text ="";
                      _textFromDate.text ="";
                      _textFromTo.text="";
                      _fromDate= DateTime.now();
                      _toDate=DateTime.now();//Utils.formatDateOnly(DateTime.now());
                      FocusScope.of(context).unfocus();
                    });
                  },
                    icon: Icon(Icons.clear)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                ],
              ),
              /*DropdownButton(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.green),
                underline: Container(
                  height: 2,
                  color: Colors.black26,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Cash', 'Credit Card', 'Online', 'Check']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),*/
            )
        ),

    ],);
  }

   Future<void> _selectDate(BuildContext context, selectedDate, txtController, type) async {

     DateTime? newSelectedDate = await showDatePicker(
         context: context,
         initialDate: selectedDate ?? DateTime.now(),
         firstDate: DateTime(2020),
         lastDate: DateTime(2060),
         builder: (context, picker) {
           return Theme(
             data: ThemeData.dark().copyWith(
               colorScheme: const ColorScheme.light(
                 primary: Colors.green,
                 onPrimary: Colors.white,
                 surface: Colors.white,
                 onSurface: Colors.black,
               ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
             ),
             child:picker!,
           );
         });

     if (newSelectedDate != null) {
       type == "fromDate"? _fromDate = newSelectedDate: _toDate=newSelectedDate;
       txtController
         ..text = Utils.formatDateOnly(newSelectedDate)
         ..selection = TextSelection.fromPosition(TextPosition(
             offset: txtController.text.length,
             affinity: TextAffinity.upstream));
     }
   }

  Row dateFilter(BuildContext context, txtFromController, txtToController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .start,
        children: [
          Flexible(
            flex: 5,
            child: TextField(
              decoration: const InputDecoration(
                labelText: "FromDate",
                icon: Icon(Icons.date_range)
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: txtFromController,
              onTap: () {
                _selectDate(context,_fromDate,txtFromController,'fromDate');
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width*0.1,),
          Flexible(
            flex: 5,
            child: TextField(
              decoration: const InputDecoration(
                labelText: "ToDate",
                icon: Icon(Icons.date_range)
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: txtToController,
              onTap: () {
                _selectDate(context,_toDate,txtToController,'toDate');
              },
            ),
          ),
         // fromDate

          //toDate
        ],
    );
  }

   void _filterDataList(String companyName, DateTime fromDate, DateTime toDate) {
      setState(() {

        _filterData = data.where((e) {
          final senderLower= e.senderName!.toLowerCase();
          final companyLower= companyName.toLowerCase();
          return companyLower != "" ? senderLower.contains(companyLower)&& (
            e.date!.compareTo(toDate) <= 0
                && e.date!.compareTo(fromDate) >= 0 ) :
          (e.date!.compareTo(toDate) <= 0
                  && e.date!.compareTo(fromDate) >= 0 );
        }).toList();

        _filterDataWithold = dataWithold.where((e) {
          final senderLower= e.senderName!.toLowerCase();
          final companyLower= companyName.toLowerCase();
          return companyLower != "" ? senderLower.contains(companyLower)&& (
              e.createdAt!.compareTo(toDate) <= 0
                  && e.createdAt!.compareTo(fromDate) >= 0 ) :
          (e.createdAt!.compareTo(toDate) <= 0
              && e.createdAt!.compareTo(fromDate) >= 0 );
        }).toList();
      });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}




