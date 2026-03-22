import 'package:flutter/material.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:get_receipt/widgets/FooterRef.dart';
import 'package:get_receipt/widgets/MainTitle.dart';
import 'package:get_receipt/widgets/main_card.dart';
import 'package:provider/provider.dart';

import '../model/local/account.dart';

class ClientDetail extends StatefulWidget {
  const ClientDetail({Key? key, required this.orgName}) : super(key: key);
  final String orgName;
  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {

  List<MainData> data =[];
  List<MainData> eachOrgData=[];
  late Account _userInfo;

  void onlySelectedOrgData(){

    eachOrgData =data.where(
            (e) {
          final nameLower= e.senderName!.toLowerCase();
          final searchLower = widget.orgName.toLowerCase();
          return nameLower.contains(searchLower) ;
          //=> e.senderName!.toLowerCase().startsWith(query.toLowerCase())).toList();
        }).toList();
    }


  @override
  Widget build(BuildContext context) {

    MainService _receiptList = Provider.of<MainService>(context, listen: false);
    UserInfoService _userInfoService = Provider.of<UserInfoService>(context, listen: false);
    _userInfo =  _userInfoService.getUserInfo();
    data =_receiptList.getPaidReceiptData(context);
    onlySelectedOrgData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.search_rounded, size: 21,),
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.08,),
              ],
            ),
          ),
        ],
      ),
      body: Column(
          children: [
          MainTitle('Clients'),
            Flexible(
              flex: 80,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: eachOrgData.length,
                        itemBuilder: (BuildContext ctx, int index){
                          return MainCard(
                            status: "paid",
                            mainData: eachOrgData[index],
                            userInfo: _userInfo,
                          );
                        }
                    ),
                  ),

                ],
              ),
            ),

          FooterRef(),
      ]
    ),
    );
  }
}
