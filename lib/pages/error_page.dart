

import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/404 Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.17),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.home),
                color: Colors.green,
                iconSize: 32,
                onPressed: () {
                  Utils.mainAppNav.currentState!.pushNamed('/welcomepage');
                },
               /* child: Text(
                  "retry".toUpperCase(),
                ),*/
              ),
            ),
          )
        ],
      ),
    );
  }
}
