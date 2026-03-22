
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:get_receipt/services/log_in_service.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:provider/provider.dart';
import '../model/local/account.dart';

import '../db/items_database.dart';
import '../db/receipt_database.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Account data;
  String? phoneNo;
  //String phoneNo = FirebaseAuth.instance.currentUser!.phoneNumber!;
  //String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context, builder: (context)=>AlertDialog(
    title: Text('Are you sure you want to Logout?', style: TextStyle(fontSize: 14),),
    actions: [
      ElevatedButton(onPressed: ()=>Navigator.pop(context, false),
        style:ButtonStyle(backgroundColor:  WidgetStateProperty.all<Color>(Colors.green) ),
        child: Text('No', style: TextStyle(color: Colors.white),),
      ),
      ElevatedButton(onPressed: ()=>Navigator.pop(context, true),
        style:ButtonStyle(backgroundColor:  WidgetStateProperty.all<Color>(Colors.green) ),
        child: Text('Yes', style: TextStyle(color: Colors.white),),
      )],
  )
  );

  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    UserInfoService _userInfo = Provider.of<UserInfoService>(context, listen: false);
    data =  _userInfo.getUserInfo();
    phoneNo = loginService.loggedInUserModel!.phoneNo!;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color:Colors.green),
        actions: [
          Container(
            child: Row(
              children:  [
               /* const Icon(Icons.search_rounded, size: 21, ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.18,),*/
                //const Icon(Icons.logout),
                IconButton(onPressed: () async {
                  final shouldPop = await showWarning(context);
                  if(shouldPop != null) {
                    if(shouldPop){
                      await ReceiptDatabase.instance.deleteAll();
                      await ItemsDatabase.instance.deleteAll();
                      loginService.signOut(context);
                    }else{
                      Container();
                    }
                    //shouldPop ? loginService.signOut(context):Container();
                  }else{
                    await ReceiptDatabase.instance.deleteAll();
                    await ItemsDatabase.instance.deleteAll();
                    loginService.signOut(context);
                  }


                },
                  icon: Icon(Icons.logout),),

                SizedBox(width: MediaQuery.of(context).size.width * 0.08,),
              ],

            ),
          ),
        ],
        /* bottom:  TabBar(
        isScrollable: false,
        indicatorColor: Colors.green,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.black38,
        controller: _tabController,
          tabs: myTabs,
        ),*/
      ),
      body: Column(
        children: [
          Flexible(flex: 17, child: Container(

            child: Column(
              children: [
               /* Container(
                  margin: EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 40,
                    child: ListTile(
                      leading: ,
                    ),
                  ),
                ),*/
                Container(
                  color:Color.fromRGBO(0, 128, 0, 0.8),

                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column( children: [
                          Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                              Container(
                              margin: EdgeInsets.only(left: 15,bottom: 10 ,top: 5),
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child:  ClipOval(
                                  child: Image.asset('assets/images/pp.png'),
                                ),
                              ),
                            ),
                          ]
                          )
                        ],),
                      ),
                      Flexible(
                        flex: 7,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(data.firstName??"", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                                      color: Colors.white),),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    text: 'ID: ',
                                    style: TextStyle(
                                        color: Colors.white70
                                    ), children: [
                                    TextSpan(text:'***233434**1' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),)
                                  ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                ),
              ],
            ),
          ),),
          Flexible(flex:73  ,child:
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:10,left: 20),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),),
                        ],
                      ),
                    ),
                    SizedBox( height: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 40),
                      child: Column(
                        children: [
                          AccountList(data.firstName??"",'First Name (Not Editable)'),
                          const Divider(),
                          AccountList(data.lastName??"",'Last Name (Not Editable)'),
                          const Divider(),
                          AccountList(phoneNo!,'Phone No (Not Editable)'),
                          const Divider(),
                          AccountList(data.orgName.toString(),'Company Name (Optional/Not Editable)'),
                          const Divider(),
                          AccountList(data.tinNo.toString(),'Tin No (Optional/Not Editable)'),
                          const Divider(),
                          AccountList(data.vatNo.toString(),'VAT No (Optional / Not Editable)'),
                          //const Divider(),
                          //AccountList(data.taxCenter??"",'Tax Center (Not Editable)'),
                        ],
                      ),
                    )
                  ],
                ),
              ),),
          Flexible(
            flex: 10,
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Power By Get Rest Technology', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),),
                ],
              ),
            ),)
        ],
      ),
    );
  }

  Column AccountList(String title, String subTitle) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height *0.02,
        ),
        Row(
          children: [
            Text(subTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black26),
            ),
          ],
        ),
      ],
    );
  }
}
