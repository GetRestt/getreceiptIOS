import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/search_delegate.dart';
import 'package:get_receipt/model/client_model.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/pages/client_detail_page.dart';
import 'package:get_receipt/widgets/FooterRef.dart';
import 'package:get_receipt/widgets/MainTitle.dart';
import 'package:provider/provider.dart';

import '../services/mainservice.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  //late Map data;
  List<MainData> data =[];
  List<MainData> distinctData =[];
  List<ClientModel> clientModel=[];
  late ClientModel singleClientModel;

  List<MainData> getDistinctData(){
    var seen = Set<String>();
    List<MainData> uniquelist = data.where((e) => seen.add(e.senderName!)).toList();
    return  uniquelist;
  }
  void mapWithClientModel(){
    distinctData = getDistinctData();
    for (var doc in distinctData) {
      singleClientModel =ClientModel(senderName:doc.senderName,
        senderAddress: doc.senderAddress,
        count:  data.where((c) => c.senderName == doc.senderName).toList().length,
      );
      clientModel.add(
          singleClientModel
      );
      //_data.add(MainData.fromJson(doc.data()));
    }
  }
  @override
  Widget build(BuildContext context) {

/*    ClientService _fromRetrieveData = Provider.of<ClientService>(context, listen: false);
    data =_fromRetrieveData.getClientMap();

*/
    MainService _receiptList = Provider.of<MainService>(context, listen: false);
    data =_receiptList.getMainData(context);
    mapWithClientModel();
/*
    _fromRetrieveData.getClientCountCollectionFromFirebase().then((value) {

    });
*/
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
                IconButton(onPressed: (){
                  showSearch(context: context, delegate: DataSearch());
                },
                  icon: Icon(Icons.search_rounded, size: 21,),
                ),
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
          /*Flexible(
          flex: 10,
          child: Container(
            color: Colors.green.withOpacity(0.8),
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
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
            ],
            )
          ),
        ),*/

          Flexible(
            flex: 80,
            child: Container(
                margin: EdgeInsets.only(left: 10, top: 15),
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                    itemCount: clientModel.length,
                    itemBuilder: (BuildContext ctx, int index){
                      return Container(
                          margin: EdgeInsets.only(left: 10, top: 15,),
                          child: Column(
                            children: [
                              ClientList( clientModel[index].senderName!, clientModel[index].senderAddress!, clientModel[index].count.toString() ), //'Afomi Restaurant','Addis Ababa, 6 Kilo','5' //data[index].key,"",data[index].value
                            ],
                          )
                      );
                    }
                ),
            ),
          ),
          FooterRef(),
        ],
      ),
    );
  }

  ElevatedButton ClientList(String cientName, String address, String count) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.all(10)),),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ClientDetail(orgName: cientName,),
        ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(cientName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(address.length <25 ? address :address.substring(0, 25),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black45),
                ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color:Colors.green,
                ),

                margin: EdgeInsets.only(right: 50,bottom: 10),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child:  ClipOval(
                      child: Center(child: Text(count, style: TextStyle(color: Colors.white, fontSize: 14),))
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
