
import 'dart:convert';

import 'package:appwrite/models.dart' as appWrite;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/auth_helper.dart';
import 'package:get_receipt/helpers/database_helper.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/services/loading_indicator_dialog.dart';
import 'package:get_receipt/services/mainservice.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../model/tax_center.dart';
import 'field_input_page.dart';

class Validation extends StatefulWidget {
  const Validation({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {

  bool codeSent = false;
  String _verificationCode ="";
  String smsCode ="";
  bool wait = true;
  String buttonName = "Wait, Please!";
  String uid = "";

  @override
  void initState() {
    _verifyPhone();
    super.initState();
/*    Future
        .wait(_verifyPhone()) //initializeAccount
        .then((value) => {
          super.initState()
    });*/
    // TODO: implement initState
  }
  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context, builder: (context)=>AlertDialog(
    content: Text('Please, wait for sms code!', style: TextStyle(fontSize: 12),),
    title: Text('Do you want to change phoneNo?', style: TextStyle(fontSize: 14),),
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
    //LoginService loginService = Provider.of<LoginService>(context, listen: false);

    return PopScope(
      canPop: true, //When false, blocks the current route from being popped.
      onPopInvokedWithResult: (didPop, result) async {
        //do your logic here:
         await showWarning(context);

      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff7f6fb),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Flexible( flex: 2,
                  child: Column( children: [
                  /*  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.black54,
                        ),
                      ),
                    ),*/
                    const SizedBox(
                      height: 18,
                    ),
                    const Text
                      (
                      'Get Receipt',
                      style:TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold, fontFamily: 'MontserratSubrayada-Bold' , color: Colors.green,)
                      ,),
                  ],)

                ),

                Flexible(
                flex: 7,
                child: Column( children:
                [
                  const Text(
                    'Phone No',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                   Text(
                    widget.phone,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black38,
                    ),
                  ),
                   SizedBox(
                    height: MediaQuery.of(context).size.height *0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("This code will expired in", style: TextStyle(color: Colors.black54),),
                      TweenAnimationBuilder(
                          tween: IntTween(begin: 90, end:0),
                          duration: const Duration(seconds: 90),
                          builder: (context, int value, child)=>Text("00:${value.toInt()}", style: TextStyle(color:Colors.green),),
                          onEnd: (){ setState(() {
                            showSnackBar(context, "Time Out, Resend again");
                            wait = false;
                            buttonName = "Resend New Code";
                          });},
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Enter your OTP code number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  codeSent ?Container(
                    padding: const EdgeInsets.only(top: 28, bottom: 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        otpField(),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textFieldOTP(first: true, last: false),
                            _textFieldOTP(first: false, last: false),
                            _textFieldOTP(first: false, last: false),
                            _textFieldOTP(first: false, last: false),
                            _textFieldOTP(first: false, last: false),
                            _textFieldOTP(first: false, last: true),
                          ],
                        ),*/
                        const SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try{

                                smsCode.length!=6? errorOtpInput() :
                                LoadingIndicatorDialog().show(context); // start dialog
                                String phoneNo = Utils.formatPhoneNo(widget.phone);
                                 await AuthHelper.instance.verifyOTP(userId: uid, otp: smsCode, phoneNo: '+251${phoneNo}', ).then((value) async {
                                   // end dialog
                                  if(value.userId != null){
                                    uid= value.userId;
                                    //uid = loginService.loggedInUserModel!.uid!; //FirebaseAuth.instance.currentUser!.uid;
                                    checkValueExist(uid);
                                  }
                                });

                              } catch(e){
                                LoadingIndicatorDialog().dismiss();
                                FocusScope.of(context).unfocus();
                                showSnackBar(context, "Invalid OTP");
                              }

                            },
                            style: ButtonStyle(
                              foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                              backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.green),
                              shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Verify',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ): Container(),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                   TextButton(
                    onPressed: wait? null : (){
                      wait = true;
                      buttonName="Wait, Please!";
                      _verifyPhone();
                    },
                    child:  Text(
                      buttonName,
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: wait? Colors.grey: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   ),
                ]
                ),
                ),
/*              const Flexible(
                  flex:1,
                  child: Text('Power By Get Rest Tech',
                    style:  TextStyle( fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black38,
                    ),

                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otpField(){
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width,
      fieldWidth: 40,
      style: const TextStyle(
          fontSize: 17
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (pin) {
        setState(() {
          smsCode= pin;
        });
      },
    );
  }

  /*Widget _textFieldOTP({required bool first, last}) {
    return SizedBox(
      height: 75,
      child: AspectRatio(
        aspectRatio: 0.4,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }*/
  void errorOtpInput(){
    FocusScope.of(context).unfocus();
    showSnackBar(context, "Missing some OTP");
  }
  void showSnackBar(BuildContext context, String message){
    final snackBar= SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void checkValueExist (String uid) async{
    UserInfoService _userInfo = Provider.of<UserInfoService>(context, listen: false);
/*    _checkIfExist() async{
      bool exist =await _userInfo.checkIfExist(uid);
    }*/
    bool exist =await _userInfo.checkIfExist(uid);


    LoadingIndicatorDialog().dismiss();
    if(exist){
      //already exist user =>home page
      Utils.mainAppNav.currentState!.pushNamed('/');
    }else{
      List<appWrite.Document> allTaxCenter = await DatabaseHelper.instance.getAllTaxCenter();
      //new user => field_input
      //Utils.mainAppNav.currentState!.pushNamed('/fieldInput');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=>FieldInput(uid, widget.phone, allTaxCenter.isNotEmpty ? Tax_center.fromJson( json.decode(allTaxCenter.first.data['Info']) ) : Tax_center.fromJson([])),
        ),
      );
    }
  }
  Future<void> _verifyPhone() async{
    String phoneNo = Utils.formatPhoneNo(widget.phone);
    //LoadingIndicatorDialog().show(context); // start dialog
    await AuthHelper.instance.loginWithNumber( '+251${phoneNo}').then((value) async {
      if (value.isNotEmpty){
         setState(() {
           uid= value;
           codeSent= true;
         });
         //checkValueExist(value); //value= uid
       }
    });

/*
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+251 ${phoneNo}',
        verificationCompleted: (PhoneAuthCredential credential) async{
          await FirebaseAuth.instance.signInWithCredential(credential)
              .then((value) async{
                uid = FirebaseAuth.instance.currentUser!.uid;
                if(value.user != null){
                  checkValueExist(uid);
                }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          showSnackBar(context, e.message.toString());
        },
        codeSent: (String verificationID, int? resendToken ){
          setState(() {
            codeSent= true;
            _verificationCode =verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID)
        {
          *//*setState(() {
            _verificationCode =verificationID;
          });*//*
        },
      timeout: const Duration(seconds: 90)
    );*/
    //LoadingIndicatorDialog().dismiss(); // end dialog
  }

}