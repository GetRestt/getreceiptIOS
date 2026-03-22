import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/widgets/AppBarRef.dart';
import 'package:get_receipt/widgets/FooterRef.dart';
import 'package:get_receipt/widgets/MainTitle.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {

  late DateTime _fromDate;
  late DateTime _toDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarRef(),
      body: Column(
        children: [
          MainTitle('Invite Friends'),
          Flexible(
            flex: 80,
            child: Container(
                margin: EdgeInsets.all(50),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.insights, size: 32, color:Colors.green,),
                            TextButton(onPressed: ()=>{
                            },
                            child: Text('Invite Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),),
                          ) ,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset('assets/images/Invite.png'),
                            ],
                          )
                        ),
                      ],
                    )
                  ],
                )
            ),
          ),
          FooterRef(),
        ],

      ),
    );
  }
}
