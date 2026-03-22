
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_receipt/helpers/search_delegate.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:get_receipt/widgets/drawerRef.dart';
import 'package:get_receipt/widgets/main_card.dart';
import 'package:provider/provider.dart';

import '../db/items_database.dart';
import '../db/receipt_database.dart';
import '../model/local/account.dart';
import '../model/local/items.dart';
import '../model/local/receipt.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  late List<MainData> _data;
  late LocalReceipt _receipt;
  late List<LocalReceipt> _receipts;
  late List<LocalItems> _items;
  late DateTime _latest;
  final List<bool> _selections =List.generate(3, (_) => false);
  late List<MainData> data = [];
  late Account _userInfo;
  String uid = "";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

/*    MainService _fromRetrieveData = Provider.of<MainService>(context, listen: false);
    data =_fromRetrieveData.getMainData();*/
    /*LoginService loginService = Provider.of<LoginService>(context, listen: false);
    UserInfoService _userInfo = Provider.of<UserInfoService>(context, listen: false);*/
    MainService _receiptList = Provider.of<MainService>(context, listen: false);
    UserInfoService _userInfoService = Provider.of<UserInfoService>(context, listen: false);
    _userInfo =  _userInfoService.getUserInfo();
    data =_receiptList.getPaidReceiptData(context);

    return RefreshIndicator(
      onRefresh: () async{
        Utils.mainAppNav.currentState!.pushNamed('/');
      },

      child: PopScope<Object?>(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          // `didPop` is true if the pop succeeded, false otherwise
          if (didPop) {
            return;
          }

          if (_scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.of(context).pop();
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DrawerRef(_userInfo.phoneNo, _userInfo.firstName, _userInfo.lastName),
          appBar: AppBar(
            title: const Text('Get Receipt',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MontserratSubrayada-Bold', color: Colors.green,),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: const IconThemeData(color:Colors.green),
            actions: [
              Container(
              child: Row(
                children:  [
                 IconButton(
                  icon: Icon(Icons.search_rounded, size: 21,),
                  onPressed: (){
                  showSearch(context: context, delegate: DataSearch());
                }, ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                const Icon(Icons.lock_outline_rounded),
                SizedBox(width: MediaQuery.of(context).size.width * 0.08,),
              ],
              ),
            ),
          ],
          ),

          body: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(padding: EdgeInsets.only(top:25, bottom: 10),
                      child: Text('My Paid Receipt',
                          textAlign:TextAlign.center
                          ,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black38)),

                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 80),
                        itemCount: data.length,
                          itemBuilder: (BuildContext ctx, int index){
                            return MainCard(
                                status:"paid",
                                mainData: data[index],
                                userInfo: _userInfo,
                            );
                          }
                      ),

                    ),
/*                Container(
                      margin: EdgeInsets.all(5) ,
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(

                                  title: const Padding(
                                    padding: EdgeInsets.only(bottom: 8, top: 10, left: 5, right: 5),
                                    child: Text('12-01-2022 14:15:45',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color:Colors.green),),
                                  ),

                                  //subtitle: Text('Dire International Hotel', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 15, ),),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(bottom: 8, top: 10,left: 5, right:5),
                                    child: RichText ( text: const TextSpan( children: [
                                      TextSpan(text: 'Sub Total : ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                                      TextSpan(text: ' 198.00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                                    ]
                                    ),
                                    ),
                                  ),),
                                Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 20, bottom: 5, top: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Dire International Hotel', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 15, ),),
                                          RichText ( text: const TextSpan( children: [
                                            TextSpan(text: 'Vat : ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                                            TextSpan(text: ' 20.00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
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
                                          Text('Status : Pending'),
                                          RichText ( text: const TextSpan( children: [
                                            TextSpan(text: 'Total : ', style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black,),),
                                            TextSpan(text: ' 218.00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green,),)
                                          ]
                                          ),
                                          ),
                                        ],
                                      ),
                                    )
                                ) ,
                                ButtonBarTheme ( // make buttons use the appropriate styles for cards
                                  data: ButtonBarThemeData(),
                                  child: ButtonBar(
                                    children: <Widget>[
                                      TextButton(
                                        child: const Text('View'),
                                        onPressed: () {},
                                      ),
                                      TextButton(
                                        child: const Text('Download'),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            elevation: 10,
                          ),
                        ],
                      ),)*/

                    /*Expanded(
                      child: ListView.builder(
                        itemCount: Data.length;
                          itemBuilder: itemBuilder))*/
                  ],
                ),
                Positioned(
                  bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset.zero,)
                        ]
                      ),
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

/*                      ToggleButtons(
                              children: [
                                IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.paid_outlined),
                                  onPressed: (){

                                  },
                                ),
                                IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.pending_actions),
                                  onPressed: (){

                                  },
                                ),
                                IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.account_circle_outlined),
                                  onPressed: (){
                                    Utils.mainAppNav.currentState!.pushNamed('/setting');
                                  },
                                ),

                              ],
                              isSelected: _selections,
                              onPressed: (int index){
                                setState(() {
                                  _selections[index] = !_selections[index];
                                });
                              },
                            color: Colors.black26,
                            selectedColor: Colors.green,
                          ),*/
                          ClipOval(
                            child: Material(
                              child:IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.paid_outlined),
                                  onPressed: (){
                                    Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
                                  },
                                ),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              child:IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.pending_actions),
                                  onPressed: (){
                                    Utils.mainAppNav.currentState!.pushNamed('/homePending');
                                  },
                                ),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              child:IconButton(
                                color: Colors.green,
                                icon:const Icon(Icons.money),
                                onPressed: (){
                                  Utils.mainAppNav.currentState!.pushNamed('/withholding');
                                },
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Material(
                              child:IconButton(
                                  color: Colors.green,
                                  icon:const Icon(Icons.account_circle_outlined),
                                  onPressed: (){
                                    /*uid = loginService.loggedInUserModel!.uid!;
                                    _userInfo.userInfoGet(uid)
                                        .then((value) {*/
                                      Utils.mainAppNav.currentState!.pushNamed('/account');
                                    /*});*/

                                  },
                                ),
                            ),
                          ),


                      ],),

                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
