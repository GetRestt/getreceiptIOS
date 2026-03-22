import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/search_delegate.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/main_data.dart';
import 'package:get_receipt/model/user_info.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:get_receipt/widgets/drawerRef.dart';
import 'package:get_receipt/widgets/main_card.dart';
import 'package:provider/provider.dart';

import '../model/local/account.dart';
import '../model/main_withhold_data.dart';
import '../services/withholding_service.dart';
import '../widgets/mainWithholdCard.dart';



class HomeWithholding extends StatefulWidget {
  const HomeWithholding({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeWithholding> with TickerProviderStateMixin{

  final List<bool> _selections =List.generate(3, (_) => false);
  late List<MainWithholdData> data;
  late Account _userInfo;

  @override
  Widget build(BuildContext context) {

/*    MainService _fromRetrieveData = Provider.of<MainService>(context, listen: false);
    data =_fromRetrieveData.getMainData();*/

    WithholdingService _pendingReceiptList = Provider.of<WithholdingService>(context, listen: false);
    UserInfoService _userInfoService = Provider.of<UserInfoService>(context, listen: false);
    _userInfo =  _userInfoService.getUserInfo();
    data =_pendingReceiptList.getMainWithholdData(context);

    return Scaffold(
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
                  child: Text('Withholding Receipt',
                      textAlign:TextAlign.center
                      ,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black38)),

                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 60),
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctx, int index){
                        return MainWithholdCard(
                          mainData: data[index],
                          userInfo: _userInfo,
                        );
                      }
                  ),

                ),
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

                      /*ToggleButtons(
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
                            icon:const Icon(Icons.settings),
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
                              Utils.mainAppNav.currentState!.pushNamed('/account');
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
    );

  }

}
