
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/pages/account_page.dart';
import 'package:get_receipt/pages/clients_page.dart';
import 'package:get_receipt/pages/invite_friend.dart';
import 'package:get_receipt/pages/report_page.dart';
import 'package:get_receipt/pages/history_page.dart';
import 'package:get_receipt/services/log_in_service.dart';
import 'package:provider/provider.dart';
import '../helpers/database_helper.dart';
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
                      Divider(height: MediaQuery.of(context).size.height *0.03, thickness: 1.0,),
                      ElevatedButton(
                        onPressed: () {
                          LoginService loginService = Provider.of<LoginService>(context, listen: false);
                          var uid = loginService.loggedInUserModel!.uid!;
                          confirmAndDelete(context, uid);
                        },
                        child: Text("Delete"),
                      )
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

  Future<void> confirmAndDelete(
      BuildContext context,
      String documentId,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text("Are you sure you want to delete this record?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes"),
            ),
          ],
        );
      },
    );

    // 🚫 User pressed cancel or closed dialog
    if (confirmed != true) return;

    // ✅ Proceed with delete
    try {
      await DatabaseHelper.instance.deleteUser(documentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete failed")),
      );
    }
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
