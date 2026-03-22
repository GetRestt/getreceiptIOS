

import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';

class FailedPage extends StatefulWidget {

  const FailedPage({Key? key, required this.errorText, required this.callPhone, required this.rewardText }) : super(key: key);

  final String errorText;
  final String callPhone;
  final String rewardText;
  @override
  State<FailedPage> createState() => _FailedPageState();
}

class _FailedPageState extends State<FailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        alignment: Alignment.center,
        child: Column(

          //fit: StackFit.expand,

          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Image.asset(
              "assets/images/failure.png",
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(widget.errorText, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.red),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            IconButton(
              icon: Icon(Icons.phone),
              color: Colors.green,
              iconSize: 32,
              onPressed: () {
                Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
              },
              /* child: Text(
                    "retry".toUpperCase(),
                  ),*/
            ),
            Text(widget.callPhone, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.red),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            Text(widget.rewardText, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green),),

          ],
        ),
      ),
    );
  }
}
