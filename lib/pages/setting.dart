import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/pages/field_input_page.dart';
import 'package:get_receipt/pages/home_page.dart';
import 'package:get_receipt/pages/invite_friend.dart';
import 'package:get_receipt/pages/report_page.dart';
import 'package:get_receipt/pages/validation_page.dart';
import 'package:get_receipt/widgets/FooterRef.dart';
import 'package:get_receipt/widgets/MainTitle.dart';

import 'account_page.dart';
import 'auth_page.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color:Colors.green),
        actions: [
          Container(
            child: Row(
              children:  [
                const Icon(Icons.search_rounded, size: 21, ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.18,),
                const Icon(Icons.logout),
                SizedBox(width: MediaQuery.of(context).size.width * 0.08,),
              ],
            ),
          ),
        ],
      ),
      body: Column(
          children: [
          MainTitle('Settings'),
          Flexible(
            flex: 80,
            child: Container(
                margin: EdgeInsets.all(25),
                child: Column(
                children: [
                    buildTextButton(context,'Account',Icons.supervisor_account, AccountPage() ),
                    SizedBox( height: 15,),
                    Divider(),
                    buildTextButton(context,'Devices',Icons.devices, Home() ),
                    SizedBox( height: 15,),
                    Divider(),
                    buildTextButton(context,'FAQ',Icons.question_answer, InviteFriends() ),
                    SizedBox( height: 15,),
                    Divider(),
                    buildTextButton(context,'Policy',Icons.policy, Reports() ),
                  ]
                )
            )
          ),
         FooterRef(),
        ],
      )
    );
  }

  TextButton buildTextButton(BuildContext context, String title, IconData iconName, Widget function ) {
    return TextButton(
      child: ListTile(
        leading: Icon(iconName,color: Colors.green,),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>function)
        );
      },
    );
  }
}
