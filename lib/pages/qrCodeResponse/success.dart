

import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';

class SuccessPage extends StatefulWidget {

  const SuccessPage({Key? key, required this.errorText}) : super(key: key);

  final String errorText;
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/success.png",
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(widget.errorText, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green),),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          IconButton(
            icon: Icon(Icons.backspace),
            color: Colors.green,
            iconSize: 32,
            onPressed: () {
              Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
            },
            /* child: Text(
                  "retry".toUpperCase(),
                ),*/
          ),

        ],
      ),
    );
  }
}
