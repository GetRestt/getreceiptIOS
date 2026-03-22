
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/pages/account_page.dart';
import 'package:get_receipt/pages/clients_page.dart';
import 'package:get_receipt/pages/invite_friend.dart';
import 'package:get_receipt/pages/report_page.dart';
import 'package:get_receipt/pages/history_page.dart';

import '../pages/qr_scan_page.dart';
import 'FooterRef.dart';

class DrawerRef extends StatefulWidget {
  const DrawerRef( this.phone, this.firstName, this.lastName, {Key? key}) : super(key: key);

  final String? phone;
  final String? firstName;
  final String? lastName;

  @override
  State<DrawerRef> createState() => _DrawerRefState();
}

class _DrawerRefState extends State<DrawerRef> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Flexible(
                flex: 25,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 5),
                        padding: EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child:  ClipOval(
                                  child: Image.asset('assets/images/pp.png'),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Text(
                              '${widget.firstName}  ${widget.lastName}',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14,),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Text(
                              widget.phone??"",style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                )
            ),
            Flexible(
                flex: 65,
                fit: FlexFit.tight,
                child: Container(
                  //margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 15, top: 10,),
                  child: Column(
                    children:  [
                      drawerTextButtonList(context,Icons.supervisor_account,'Account',AccountPage()),
                      Divider(height: MediaQuery.of(context).size.height *0.05, thickness: 1.0,),
                      drawerTextButtonList(context,Icons.history,'History',History()),
                      Divider(height: MediaQuery.of(context).size.height *0.05, thickness: 1.0,),
                      drawerTextButtonList(context,Icons.business,'Clients',ClientsPage()),
/*                        Divider(),
                        drawerTextButtonList(context,Icons.shopping_cart_rounded,'Gateway',Client()),*/
                      Divider(height: MediaQuery.of(context).size.height *0.05, thickness: 1.0,),
                      drawerTextButtonList(context,Icons.assessment_outlined,'Report',Reports()),
                      /*Divider(height: MediaQuery.of(context).size.height *0.05, thickness: 1.0,),
                      drawerTextButtonList(context,Icons.settings_overscan,'QR Scaner',QrCodeScan()),*/
                      Divider(height: MediaQuery.of(context).size.height *0.05, thickness: 1.0,),
                      drawerTextButtonList(context,Icons.arrow_forward_outlined,'Invite Friends',InviteFriends()),
                      //Divider(height: MediaQuery.of(context).size.height *0.03, thickness: 1.0,),
                      //drawerTextButtonList(context,Icons.settings,'Settings',Setting()),
                    ],
                  ),
                )
            ),
            FooterRef(),
          ],
        ),
      ),
    );
  }

  TextButton drawerTextButtonList(BuildContext context, IconData icon, String title, Widget pageTo) {
    return TextButton(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon,color: Colors.green,),
          SizedBox(width: MediaQuery.of(context).size.width*0.07),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),),
        ],
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>pageTo)
        );
      },
    );
  }
}
