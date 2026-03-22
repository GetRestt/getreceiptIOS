

import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appWrite;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/database_helper.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/pages/field_input_page.dart';
import 'package:get_receipt/services/log_in_service.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:provider/provider.dart';

import '../model/tax_center.dart';
import '../services/withholding_service.dart';

class Splash extends StatelessWidget {
  int? duration = 0;
  String? goToPage;
  String? uid;
  String? phoneNo;
  Splash({Key? key,  this.goToPage, this.duration }) : super(key: key);
  late bool _isLogin;
  @override
  Widget build(BuildContext context) {
    LoginService loginService = Provider.of<LoginService>(context, listen: false);

    Future.delayed(Duration(seconds: duration!), () async {

      //await for the Firebase initialization to occur
      //FirebaseApp app = await Firebase.initializeApp();
      _isLogin =await loginService.loginUser();
      if(_isLogin){
        // user login
        uid = loginService.loggedInUserModel!.uid!;

        try {
          uid = loginService.loggedInUserModel!.uid!;
          phoneNo= loginService.loggedInUserModel!.phoneNo;
          //ReceiptList maService = Provider.of<ReceiptList>(context, listen: false);
          MainService _mainService = Provider.of<MainService>(context, listen: false);
          WithholdingService _withholdService = Provider.of<WithholdingService>(context, listen: false);
          UserInfoService _userInfo = Provider.of<UserInfoService>(context, listen: false);

          //final paidReceipt= maService.getPaidReceiptCollectionFromFirebase(phoneNo); //for home & report
          //final pendingReceipt= maService.getPendingReceiptCollectionFromFirebase(phoneNo); //for pending
          //final clientList=_clientList.getClientCountCollectionFromFirebase(); //for client
          bool exist =await _userInfo.checkIfExist(uid);
          if(exist){

            final initializeAccount= _userInfo.userInfoGet(uid); //forAccount
            final allReceipt= _mainService.getAllReceiptCollectionFromFirebase(phoneNo); //for history
            final allWithholdingReceipt= _withholdService.getAllWithholdingCollectionFromFirebase(phoneNo);
            Future
                .wait([ initializeAccount,allReceipt, allWithholdingReceipt]) //initializeAccount //paidReceipt,pendingReceipt
                .then((value) => {
              //Tax_center tc = Tax_center.fromJson(receiptCollection),
              Utils.mainAppNav.currentState!.pushNamed(goToPage!)

            });

          }else{
            List<appWrite.Document>  allTaxCenter =  await DatabaseHelper.instance.getAllTaxCenter();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context)=>FieldInput(uid!, phoneNo!, allTaxCenter.isNotEmpty ? Tax_center.fromJson(json.decode(allTaxCenter.first.data['Info'] ) ) : Tax_center.fromJson([]) ),
              ),
            );
          }



/*        maService.getPaidReceiptCollectionFromFirebase()//getMainCollectionFromFirebase
            .then((value) {
          Utils.mainAppNav.currentState!.pushNamed(goToPage!);
        });*/

        }on AppwriteException catch(e){
          Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
        }

      }else{
        Utils.mainAppNav.currentState!.pushNamed('/auth');
      }
      //uid = loginService.loggedInUserModel!.uid;

    });

    return Material(
        child: Container(

            //color: const Color(0xFF80C038),
            alignment: Alignment.center,
            child: Stack(
              children: [

                 Align(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/icons/icon.png'),
                  ),
                  alignment: Alignment.center,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green.withOpacity(0.5)),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}
